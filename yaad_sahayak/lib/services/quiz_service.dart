import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family_member_model.dart';
import '../models/quiz_result_model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a quiz using 5 random family members
  Future<List<FamilyMemberModel>> generateQuizForUser(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .get();

    final members = snapshot.docs.map((doc) {
      return FamilyMemberModel.fromMap(doc.data());
    }).toList();

    members.shuffle(Random());

    return members.take(5).toList();
  }

  // Save quiz result
  Future<void> saveQuizResult(String uid, int score, int total) async {
    final docRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('quizResults')
        .doc();

    final result = QuizResultModel(
      id: docRef.id,
      score: score,
      total: total,
      date: DateTime.now(),
    );

    await docRef.set(result.toMap());
  }

  // Get quiz history
  Stream<List<QuizResultModel>> getQuizHistory(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('quizResults')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return QuizResultModel.fromMap(doc.data());
          }).toList();
        });
  }
}
