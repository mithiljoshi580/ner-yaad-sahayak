import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  // ============================================================
  // FINAL SECURITY THRESHOLD
  // ============================================================

  static const double confidenceThreshold = 0.78;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static const String _faceKey = 'face_embedding';

  static const String _familyFacesCacheKey =
      'family_faces_cache';

  static const String _familyMembersCacheKey =
      'family_members_cache';

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser =>
      FirebaseAuth.instance.currentUser;

  // ============================================================
  // SAVE FACE LOCALLY
  // ============================================================

  Future<void> saveFace(
    List<double> embedding,
  ) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        _faceKey,
        jsonEncode(embedding),
      );

      debugPrint('Face saved locally');
    } catch (e) {
      debugPrint('Error saving face: $e');
    }
  }

  // ============================================================
  // GET SAVED FACE
  // ============================================================

  Future<List<double>?> getSavedFace() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final data =
          prefs.getString(_faceKey);

      if (data == null || data.isEmpty) {
        return null;
      }

      final List<dynamic> decoded =
          jsonDecode(data);

      return decoded
          .map(
            (value) =>
                (value as num).toDouble(),
          )
          .toList();
    } catch (e) {
      debugPrint(
        'Error getting saved face: $e',
      );

      return null;
    }
  }

  // ============================================================
  // EUCLIDEAN DISTANCE
  // ============================================================

  double _calculateDistance(
    List<double> face1,
    List<double> face2,
  ) {
    if (face1.length != face2.length) {
      return double.infinity;
    }

    double sum = 0.0;

    for (int i = 0;
        i < face1.length;
        i++) {
      final difference =
          face1[i] - face2[i];

      sum +=
          difference * difference;
    }

    return sqrt(sum);
  }

  // ============================================================
  // CONFIDENCE
  // ============================================================

  double calculateConfidence(
    List<double> face1,
    List<double> face2,
  ) {
    final distance =
        _calculateDistance(
      face1,
      face2,
    );

    if (distance ==
        double.infinity) {
      return 0.0;
    }

    final confidence =
        1 - (distance / 80);

    return confidence.clamp(
      0.0,
      1.0,
    );
  }

  // ============================================================
  // VERIFY SAVED FACE
  // ============================================================

  Future<bool> recognizeFace(
    List<double> currentEmbedding,
  ) async {
    try {
      final savedEmbedding =
          await getSavedFace();

      if (savedEmbedding == null) {
        debugPrint(
          'No saved face found',
        );

        return false;
      }

      final confidence =
          calculateConfidence(
        currentEmbedding,
        savedEmbedding,
      );

      debugPrint(
        'Face confidence: '
        '${confidence.toStringAsFixed(2)}',
      );

      return confidence >=
          confidenceThreshold;
    } catch (e) {
      debugPrint(
        'Face recognition error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // BEST MATCH CONFIDENCE
  // ============================================================

  Future<double>
      getBestMatchConfidence(
    List<double> currentEmbedding,
  ) async {
    try {
      final savedEmbedding =
          await getSavedFace();

      if (savedEmbedding == null) {
        return 0.0;
      }

      return calculateConfidence(
        currentEmbedding,
        savedEmbedding,
      );
    } catch (e) {
      debugPrint(
        'Error calculating confidence: $e',
      );

      return 0.0;
    }
  }

  // ============================================================
  // SAVE FAMILY MEMBER FACE
  // ============================================================

  Future<void>
      saveFaceForFamilyMember(
    String memberId,
    List<double> embedding,
  ) async {
    try {
      final user = currentUser;

      if (user == null) {
        debugPrint(
          'Cannot save family face: '
          'user not logged in',
        );

        return;
      }

      await _firestore
          .collection('family_members')
          .doc(memberId)
          .set(
        {
          'memberId': memberId,
          'userId': user.uid,
          'faceEmbedding': embedding,
          'faceEnrolled': true,
          'updatedAt':
              FieldValue.serverTimestamp(),
        },
        SetOptions(
          merge: true,
        ),
      );

      debugPrint(
        'Face saved for family member: '
        '$memberId',
      );

      await _cacheFamilyFace(
        memberId,
        embedding,
      );

      // Refresh family-member cache
      await clearFamilyMembersCache();
    } catch (e) {
      debugPrint(
        'Error saving family member face: $e',
      );
    }
  }

  // ============================================================
  // CACHE FAMILY FACE
  // ============================================================

  Future<void> _cacheFamilyFace(
    String memberId,
    List<double> embedding,
  ) async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      Map<String, dynamic> cache = {};

      final existing =
          prefs.getString(
        _familyFacesCacheKey,
      );

      if (existing != null &&
          existing.isNotEmpty) {
        final decoded =
            jsonDecode(existing);

        if (decoded is Map) {
          cache =
              Map<String, dynamic>.from(
            decoded,
          );
        }
      }

      cache[memberId] =
          embedding;

      await prefs.setString(
        _familyFacesCacheKey,
        jsonEncode(cache),
      );
    } catch (e) {
      debugPrint(
        'Error caching family face: $e',
      );
    }
  }

  // ============================================================
  // GET FAMILY FACES
  // ============================================================

  Future<Map<String, List<double>>>
      getFamilyFaces() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      final data =
          prefs.getString(
        _familyFacesCacheKey,
      );

      if (data == null ||
          data.isEmpty) {
        return {};
      }

      final decoded =
          jsonDecode(data);

      if (decoded is! Map) {
        return {};
      }

      final Map<String, List<double>>
          result = {};

      decoded.forEach(
        (key, value) {
          if (value is List) {
            result[key.toString()] =
                value
                    .map(
                      (item) =>
                          (item as num)
                              .toDouble(),
                    )
                    .toList();
          }
        },
      );

      return result;
    } catch (e) {
      debugPrint(
        'Error getting family faces: $e',
      );

      return {};
    }
  }

  // ============================================================
  // GET ALL SAVED FAMILY MEMBERS
  // ============================================================

  Future<List<Map<String, dynamic>>>
      getAllSavedFaces(
    String userId, {
    bool useCache = true,
  }) async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      // --------------------------------------------------------
      // USE CACHE
      // --------------------------------------------------------

      if (useCache) {
        final cached =
            prefs.getString(
          _familyMembersCacheKey,
        );

        if (cached != null &&
            cached.isNotEmpty) {
          try {
            final decoded =
                jsonDecode(cached);

            if (decoded is List) {
              return decoded
                  .map(
                    (item) =>
                        Map<String, dynamic>.from(
                      item as Map,
                    ),
                  )
                  .toList();
            }
          } catch (e) {
            debugPrint(
              'Invalid family cache: $e',
            );
          }
        }
      }

      // --------------------------------------------------------
      // FIRESTORE
      // --------------------------------------------------------

      final snapshot =
          await _firestore
              .collection(
                'family_members',
              )
              .where(
                'userId',
                isEqualTo: userId,
              )
              .get();

      final List<Map<String, dynamic>>
          members = [];

      for (final doc
          in snapshot.docs) {
        final data =
            Map<String, dynamic>.from(
          doc.data(),
        );

        // Make sure memberId exists
        data['memberId'] ??=
            doc.id;

        // Keep document ID available
        data['docId'] = doc.id;

        members.add(data);
      }

      // --------------------------------------------------------
      // SAVE CACHE
      // --------------------------------------------------------

      await prefs.setString(
        _familyMembersCacheKey,
        jsonEncode(members),
      );

      debugPrint(
        'Loaded ${members.length} '
        'family members',
      );

      return members;
    } catch (e) {
      debugPrint(
        'Error getting all saved faces: $e',
      );

      return [];
    }
  }

  // ============================================================
  // IDENTIFY FAMILY MEMBER
  // ============================================================

  Future<String?>
      identifyFamilyMember(
    List<double> currentEmbedding,
  ) async {
    try {
      final familyFaces =
          await getFamilyFaces();

      if (familyFaces.isEmpty) {
        debugPrint(
          'No family faces available',
        );

        return null;
      }

      String? bestMemberId;

      double bestConfidence = 0.0;

      for (final entry
          in familyFaces.entries) {
        final confidence =
            calculateConfidence(
          currentEmbedding,
          entry.value,
        );

        debugPrint(
          'Member ${entry.key} '
          'confidence: '
          '${confidence.toStringAsFixed(2)}',
        );

        if (confidence >
            bestConfidence) {
          bestConfidence =
              confidence;

          bestMemberId =
              entry.key;
        }
      }

      if (bestMemberId != null &&
          bestConfidence >=
              confidenceThreshold) {
        debugPrint(
          'Family member matched: '
          '$bestMemberId',
        );

        return bestMemberId;
      }

      debugPrint(
        'No family member matched. '
        'Best confidence: '
        '${bestConfidence.toStringAsFixed(2)}',
      );

      return null;
    } catch (e) {
      debugPrint(
        'Family identification error: $e',
      );

      return null;
    }
  }

  // ============================================================
  // LIVENESS CHECK
  // ============================================================

  Future<bool> livenessCheck({
    required bool blinkDetected,
    required bool smileDetected,
  }) async {
    return blinkDetected ||
        smileDetected;
  }

  // ============================================================
  // CLEAR ALL FACE CACHE
  // ============================================================

  Future<void> clearCache() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.remove(
        _faceKey,
      );

      await prefs.remove(
        _familyFacesCacheKey,
      );

      await prefs.remove(
        _familyMembersCacheKey,
      );

      debugPrint(
        'Face recognition cache cleared',
      );
    } catch (e) {
      debugPrint(
        'Error clearing face cache: $e',
      );
    }
  }

  // ============================================================
  // CLEAR FAMILY MEMBERS CACHE
  // ============================================================

  Future<void>
      clearFamilyMembersCache() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.remove(
        _familyMembersCacheKey,
      );

      debugPrint(
        'Family members cache cleared',
      );
    } catch (e) {
      debugPrint(
        'Error clearing family members cache: $e',
      );
    }
  }

  // ============================================================
  // DELETE SAVED FACE
  // ============================================================

  Future<void>
      deleteSavedFace() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.remove(
        _faceKey,
      );

      debugPrint(
        'Saved face deleted',
      );
    } catch (e) {
      debugPrint(
        'Error deleting saved face: $e',
      );
    }
  }

  // ============================================================
  // CLEAR FAMILY FACE CACHE
  // ============================================================

  Future<void>
      clearFamilyFacesCache() async {
    try {
      final prefs =
          await SharedPreferences
              .getInstance();

      await prefs.remove(
        _familyFacesCacheKey,
      );

      debugPrint(
        'Family face cache cleared',
      );
    } catch (e) {
      debugPrint(
        'Error clearing family face cache: $e',
      );
    }
  }
}