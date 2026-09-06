import 'package:cloud_firestore/cloud_firestore.dart';

class StatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats(String uid) async {
    // Get family members
    final familySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .get();

    // Get memories
    final memorySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('memories')
        .get();

    // Get quiz results
    final quizSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('quizResults')
        .get();

    // Calculate average quiz score
    double avgQuizScore = 0;

    if (quizSnapshot.docs.isNotEmpty) {
      double totalPercentage = 0;

      for (final doc in quizSnapshot.docs) {
        final data = doc.data();

        final score = (data['score'] ?? 0) as num;
        final total = (data['total'] ?? 0) as num;

        if (total > 0) {
          totalPercentage += (score / total) * 100;
        }
      }

      avgQuizScore = totalPercentage / quizSnapshot.docs.length;
    }

    // Get last active time
    DateTime? lastActive;

    if (quizSnapshot.docs.isNotEmpty) {
      for (final doc in quizSnapshot.docs) {
        final data = doc.data();

        final timestamp = data['date'];

        if (timestamp is Timestamp) {
          final date = timestamp.toDate();

          if (lastActive == null || date.isAfter(lastActive)) {
            lastActive = date;
          }
        }
      }
    }

    return {
      'totalFamilyMembers': familySnapshot.docs.length,
      'totalMemories': memorySnapshot.docs.length,
      'avgQuizScore': avgQuizScore,
      'lastActive': lastActive,
    };
  }
}
