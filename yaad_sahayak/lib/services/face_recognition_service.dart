import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  static const String _faceKey = 'saved_face_embedding';

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  // ==============================
  // DAY 2 - LOCAL FACE
  // ==============================

  Future<void> saveFace(List<double> embedding) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _faceKey,
      jsonEncode(embedding),
    );
  }

  Future<List<double>?> getSavedFace() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString(_faceKey);

    if (data == null) {
      return null;
    }

    final List<dynamic> decoded = jsonDecode(data);

    return decoded
        .map((e) => (e as num).toDouble())
        .toList();
  }

  // ==============================
  // DISTANCE
  // ==============================

  double calculateDistance(
    List<double> savedEmbedding,
    List<double> currentEmbedding,
  ) {
    if (savedEmbedding.length != currentEmbedding.length) {
      return double.infinity;
    }

    double distance = 0;

    for (int i = 0;
        i < savedEmbedding.length;
        i++) {
      final difference =
          savedEmbedding[i] -
              currentEmbedding[i];

      distance += difference * difference;
    }

    return sqrt(distance);
  }

  // ==============================
  // DAY 3 - SAVE FAMILY FACE
  // ==============================

  Future<void> saveFaceForFamilyMember(
    String memberId,
    List<double> faceEmbedding,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('familyMembers')
        .doc(memberId)
        .set(
      {
        'faceEmbedding': faceEmbedding,
      },
      SetOptions(merge: true),
    );
  }

  // ==============================
  // DAY 3 - GET SAVED FACES
  // ==============================

  Future<List<Map<String, dynamic>>> getAllSavedFaces(
    String uid,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .get();

    final List<Map<String, dynamic>> members = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (data['faceEmbedding'] != null) {
        members.add({
          'memberId': doc.id,
          ...data,
        });
      }
    }

    return members;
  }

  // ==============================
  // DAY 3 - IDENTIFY FAMILY MEMBER
  // ==============================

  Future<String?> identifyFamilyMember(
    List<double> liveEmbedding,
  ) async {
    final user = _auth.currentUser;

    if (user == null ||
        liveEmbedding.isEmpty) {
      return null;
    }

    final members =
        await getAllSavedFaces(user.uid);

    double smallestDistance =
        double.infinity;

    String? matchedMemberId;

    for (final member in members) {
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

      if (distance < smallestDistance) {
        smallestDistance = distance;
        matchedMemberId =
            member['memberId'];
      }
    }

    if (smallestDistance < 80) {
      return matchedMemberId;
    }

    return null;
  }

  // ==============================
  // DAY 2 - VERIFY
  // ==============================

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

    return distance < 80;
  }

  // ==============================
  // DELETE LOCAL FACE
  // ==============================

  Future<void> deleteSavedFace() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_faceKey);
  }
}