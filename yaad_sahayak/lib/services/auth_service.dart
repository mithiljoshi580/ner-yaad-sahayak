import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'face_recognition_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================= SIGN UP =================
  Future<User?> signUp(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({
          'name': name,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      debugPrint('Sign up error: $e');
      return null;
    }
  }

  // ================= SIGN IN =================
  Future<User?> signIn(
    String email,
    String password,
  ) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      debugPrint('Sign in error: $e');
      return null;
    }
  }

  // ================= SIGN OUT =================
  Future<void> signOut() async {
    try {
      // Clear locally cached face recognition data
      final faceService = FaceRecognitionService();

      await faceService.clearCache();

      // Sign out Firebase user
      await _auth.signOut();

      debugPrint(
        'User logged out and face cache cleared',
      );
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }
}