import 'package:cloud_firestore/cloud_firestore.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save user progress
  Future<void> saveUserProgress(String uid, String gameId, int score) async {
    await _firestore.collection('users').doc(uid).collection('progress').add({
      'score': score,
      'completedAt': FieldValue.serverTimestamp(),
      'gameId': gameId,
    });
  }

  // Fetch all progress of a user
  Future<List<Map<String, dynamic>>> getUserProgress(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }
}
