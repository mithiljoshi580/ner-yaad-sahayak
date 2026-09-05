import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionService {
  static const String _faceKey = 'saved_face_embedding';

  // Save face data locally
  Future<void> saveFace(List<double> embedding) async {
    final prefs = await SharedPreferences.getInstance();

    final data = jsonEncode(embedding);

    await prefs.setString(_faceKey, data);
  }

  // Get saved face data
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

  // Calculate distance between two embeddings
  double calculateDistance(
    List<double> savedEmbedding,
    List<double> currentEmbedding,
  ) {
    if (savedEmbedding.length != currentEmbedding.length) {
      return double.infinity;
    }

    double distance = 0;

    for (int i = 0; i < savedEmbedding.length; i++) {
      final difference =
          savedEmbedding[i] - currentEmbedding[i];

      distance += difference * difference;
    }

    return sqrt(distance);
  }

  // Verify face
  Future<bool> recognizeFace(
    List<double> currentEmbedding,
  ) async {
    final savedEmbedding = await getSavedFace();

    // No face saved
    if (savedEmbedding == null) {
      return false;
    }

    // Empty data
    if (currentEmbedding.isEmpty) {
      return false;
    }

    // Calculate distance
    final distance = calculateDistance(
      savedEmbedding,
      currentEmbedding,
    );

    // Dummy threshold
    // Higher value = easier matching
    return distance < 80;
  }

  // Delete saved face (optional)
  Future<void> deleteSavedFace() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_faceKey);
  }
}