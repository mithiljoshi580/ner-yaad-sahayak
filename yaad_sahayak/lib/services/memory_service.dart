import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save a memory
  Future<void> saveMemory(
    String uid,
    String memberId,
    String imageUrl,
    String note,
  ) async {
    await _firestore.collection('users').doc(uid).collection('memories').add({
      'imageUrl': imageUrl,
      'note': note,
      'createdAt': Timestamp.now(),
      'memberId': memberId,
    });
  }

  // Get all memories for a specific family member
  Future<List<Map<String, dynamic>>> getMemoriesForMember(
    String uid,
    String memberId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('memories')
        .where('memberId', isEqualTo: memberId)
        .get();

    return snapshot.docs.map((doc) {
      return {'id': doc.id, ...doc.data()};
    }).toList();
  }

  // Get family member by face ID
  Future<Map<String, dynamic>?> getMemberByFaceId(
    String uid,
    String faceId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .where('faceId', isEqualTo: faceId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return {'id': snapshot.docs.first.id, ...snapshot.docs.first.data()};
    }

    return null;
  }
}
