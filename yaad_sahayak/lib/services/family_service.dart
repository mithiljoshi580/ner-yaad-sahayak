import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/family_member_model.dart';

class FamilyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a family member
  Future<void> addFamilyMember(String uid, FamilyMemberModel member) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .doc(member.id)
        .set(member.toMap());
  }

  // Get all family members
  Stream<List<FamilyMemberModel>> getAllFamilyMembers(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FamilyMemberModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Get a family member by ID
  Future<FamilyMemberModel?> getFamilyMemberById(
    String uid,
    String memberId,
  ) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .doc(memberId)
        .get();

    if (doc.exists && doc.data() != null) {
      return FamilyMemberModel.fromMap(doc.data()!);
    }

    return null;
  }

  // Delete a family member
  Future<void> deleteFamilyMember(String uid, String memberId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('familyMembers')
        .doc(memberId)
        .delete();
  }
}
