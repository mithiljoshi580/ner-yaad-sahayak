import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  static const String _faceKey = 'saved_face_embedding';
  static const String _familyFacesCacheKey =
      'family_faces_cache';

  // Day 4 confidence threshold
  static const double confidenceThreshold = 0.75;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // SAVE SINGLE LOCAL FACE
  // ============================================================

  Future<void> saveFace(
    List<double> embedding,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _faceKey,
      jsonEncode(embedding),
    );
  }

  // ============================================================
  // GET SINGLE LOCAL FACE
  // ============================================================

  Future<List<double>?> getSavedFace() async {
    final prefs =
        await SharedPreferences.getInstance();

    final data =
        prefs.getString(_faceKey);

    if (data == null) {
      return null;
    }

    try {
      final List<dynamic> decoded =
          jsonDecode(data);

      return decoded
          .map(
            (e) => (e as num).toDouble(),
          )
          .toList();
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // CALCULATE DISTANCE
  // ============================================================

  double calculateDistance(
    List<double> savedEmbedding,
    List<double> currentEmbedding,
  ) {
    if (savedEmbedding.length !=
        currentEmbedding.length) {
      return double.infinity;
    }

    double distance = 0;

    for (int i = 0;
        i < savedEmbedding.length;
        i++) {
      final difference =
          savedEmbedding[i] -
              currentEmbedding[i];

      distance +=
          difference * difference;
    }

    return sqrt(distance);
  }

  // ============================================================
  // CONVERT DISTANCE TO CONFIDENCE
  // ============================================================

  double calculateConfidence(
    double distance,
  ) {
    if (distance == double.infinity) {
      return 0.0;
    }

    // Distance 0 = 100% confidence
    // Distance 80 or more = 0% confidence
    final confidence =
        1.0 - (distance / 80.0);

    return confidence
        .clamp(0.0, 1.0);
  }

  // ============================================================
  // SAVE FACE FOR FAMILY MEMBER
  // ============================================================

  Future<void> saveFaceForFamilyMember(
    String memberId,
    List<double> faceEmbedding,
  ) async {
    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User is not logged in',
      );
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('familyMembers')
        .doc(memberId)
        .set(
      {
        'faceEmbedding':
            faceEmbedding,
        'faceTrainedAt':
            FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    // Update local cache also
    await _updateCachedMemberFace(
      memberId,
      faceEmbedding,
    );
  }

  // ============================================================
  // GET ALL SAVED FAMILY FACES
  // ============================================================

  Future<List<Map<String, dynamic>>>
      getAllSavedFaces(
    String uid, {
    bool useCache = true,
  }) async {
    final prefs =
        await SharedPreferences.getInstance();

    // First try local cache
    if (useCache) {
      final cached =
          prefs.getString(
        _familyFacesCacheKey,
      );

      if (cached != null) {
        try {
          final List<dynamic> decoded =
              jsonDecode(cached);

          return decoded
              .map(
                (e) =>
                    Map<String, dynamic>.from(e),
              )
              .toList();
        } catch (e) {
          // If cache is corrupted,
          // fetch fresh data below.
        }
      }
    }

    // Fetch from Firestore
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('familyMembers')
            .get();

    final List<Map<String, dynamic>>
        members = [];

    for (final doc
        in snapshot.docs) {
      final data =
          doc.data();

      if (data['faceEmbedding'] !=
          null) {
        members.add({
          'memberId': doc.id,
          ...data,
        });
      }
    }

    // Save fetched data locally
    await _saveFamilyFacesCache(
      members,
    );

    return members;
  }

  // ============================================================
  // SAVE FAMILY FACE CACHE
  // ============================================================

  Future<void> _saveFamilyFacesCache(
    List<Map<String, dynamic>>
        members,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setString(
      _familyFacesCacheKey,
      jsonEncode(members),
    );
  }

  // ============================================================
  // UPDATE ONE MEMBER IN CACHE
  // ============================================================

  Future<void> _updateCachedMemberFace(
    String memberId,
    List<double> embedding,
  ) async {
    final prefs =
        await SharedPreferences.getInstance();

    final cached =
        prefs.getString(
      _familyFacesCacheKey,
    );

    if (cached == null) {
      return;
    }

    try {
      final List<dynamic> decoded =
          jsonDecode(cached);

      final members =
          decoded
              .map(
                (e) =>
                    Map<String, dynamic>.from(e),
              )
              .toList();

      bool found = false;

      for (final member
          in members) {
        if (member['memberId'] ==
            memberId) {
          member['faceEmbedding'] =
              embedding;
          found = true;
          break;
        }
      }

      if (!found) {
        members.add({
          'memberId': memberId,
          'faceEmbedding': embedding,
        });
      }

      await _saveFamilyFacesCache(
        members,
      );
    } catch (e) {
      // Ignore cache errors.
    }
  }

  // ============================================================
  // IDENTIFY FAMILY MEMBER
  // ============================================================

  Future<String?> identifyFamilyMember(
    List<double> liveEmbedding,
  ) async {
    final user =
        _auth.currentUser;

    if (user == null ||
        liveEmbedding.isEmpty) {
      return null;
    }

    // Use local cache for faster matching
    final members =
        await getAllSavedFaces(
      user.uid,
      useCache: true,
    );

    double bestConfidence = 0.0;
    String? matchedMemberId;

    for (final member
        in members) {
      final savedData =
          member['faceEmbedding'];

      if (savedData == null) {
        continue;
      }

      final savedEmbedding =
          (savedData as List)
              .map(
                (e) =>
                    (e as num).toDouble(),
              )
              .toList();

      final distance =
          calculateDistance(
        savedEmbedding,
        liveEmbedding,
      );

      final confidence =
          calculateConfidence(
        distance,
      );

      if (confidence >
          bestConfidence) {
        bestConfidence =
            confidence;

        matchedMemberId =
            member['memberId'];
      }
    }

    // Day 4 requirement:
    // confidence must be greater than 0.75
    if (matchedMemberId != null &&
        bestConfidence >
            confidenceThreshold) {
      return matchedMemberId;
    }

    return null;
  }

  // ============================================================
  // GET MATCH CONFIDENCE
  // ============================================================

  Future<double> getBestMatchConfidence(
    List<double> liveEmbedding,
  ) async {
    final user =
        _auth.currentUser;

    if (user == null ||
        liveEmbedding.isEmpty) {
      return 0.0;
    }

    final members =
        await getAllSavedFaces(
      user.uid,
      useCache: true,
    );

    double bestConfidence = 0.0;

    for (final member
        in members) {
      final savedData =
          member['faceEmbedding'];

      if (savedData == null) {
        continue;
      }

      final savedEmbedding =
          (savedData as List)
              .map(
                (e) =>
                    (e as num).toDouble(),
              )
              .toList();

      final distance =
          calculateDistance(
        savedEmbedding,
        liveEmbedding,
      );

      final confidence =
          calculateConfidence(
        distance,
      );

      if (confidence >
          bestConfidence) {
        bestConfidence =
            confidence;
      }
    }

    return bestConfidence;
  }

  // ============================================================
  // LIVENESS CHECK - UI PLACEHOLDER
  // ============================================================

  Future<bool> livenessCheck({
    bool blinkDetected = false,
    bool smileDetected = false,
  }) async {
    // Day 4 UI-level liveness check.
    //
    // Actual blink/smile detection can be connected
    // later using ML Kit face landmarks/expressions.

    return blinkDetected ||
        smileDetected;
  }

  // ============================================================
  // OLD LOCAL FACE RECOGNITION
  // ============================================================

  Future<bool> recognizeFace(
    List<double> currentEmbedding,
  ) async {
    final savedEmbedding =
        await getSavedFace();

    if (savedEmbedding == null ||
        currentEmbedding.isEmpty) {
      return false;
    }

    final distance =
        calculateDistance(
      savedEmbedding,
      currentEmbedding,
    );

    final confidence =
        calculateConfidence(
      distance,
    );

    return confidence >
        confidenceThreshold;
  }

  // ============================================================
  // CLEAR LOCAL FACE
  // ============================================================

  Future<void> deleteSavedFace() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _faceKey,
    );
  }

  // ============================================================
  // CLEAR FAMILY FACE CACHE
  // ============================================================

  Future<void> clearFamilyFaceCache() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      _familyFacesCacheKey,
    );
  }
}