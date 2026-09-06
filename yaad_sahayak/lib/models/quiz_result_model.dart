import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResultModel {
  final String id;
  final int score;
  final int total;
  final DateTime date;

  QuizResultModel({
    required this.id,
    required this.score,
    required this.total,
    required this.date,
  });

  // Convert model to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score': score,
      'total': total,
      'date': Timestamp.fromDate(date),
    };
  }

  // Create model from Firestore data
  factory QuizResultModel.fromMap(Map<String, dynamic> map) {
    return QuizResultModel(
      id: map['id'] ?? '',
      score: map['score'] ?? 0,
      total: map['total'] ?? 0,
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}
