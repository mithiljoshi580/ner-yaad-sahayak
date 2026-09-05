import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyMemberModel {
  final String id;
  final String name;
  final String relation;
  final String photoUrl;
  final String voiceNoteUrl;
  final String about;
  final DateTime createdAt;

  FamilyMemberModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.photoUrl,
    required this.voiceNoteUrl,
    required this.about,
    required this.createdAt,
  });

  // Convert model to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'photoUrl': photoUrl,
      'voiceNoteUrl': voiceNoteUrl,
      'about': about,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create model from Firestore data
  factory FamilyMemberModel.fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      voiceNoteUrl: map['voiceNoteUrl'] ?? '',
      about: map['about'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
