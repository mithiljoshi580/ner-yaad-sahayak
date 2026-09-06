import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isRecording = false;

  // =========================
  // START RECORDING
  // =========================
  Future<void> startRecording() async {
    try {
      final hasPermission =
          await _recorder.hasPermission();

      if (!hasPermission) {
        throw Exception(
          'Microphone permission denied',
        );
      }

      final directory =
          await getTemporaryDirectory();

      final path =
          '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
        ),
        path: path,
      );

      _isRecording = true;

      print('Recording started');
    } catch (e) {
      print('Recording error: $e');
    }
  }

  // =========================
  // STOP RECORDING
  // =========================
  Future<String?> stopRecording() async {
    try {
      if (!_isRecording) {
        return null;
      }

      final path = await _recorder.stop();

      _isRecording = false;

      print('Recording stopped: $path');

      return path;
    } catch (e) {
      print('Stop recording error: $e');
      return null;
    }
  }

  // =========================
  // SAVE VOICE TO FIREBASE
  // =========================
  Future<String> saveVoiceToStorage(
    String uid,
    String memberId,
    String filePath,
  ) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        throw Exception(
          'Voice file does not exist',
        );
      }

      final storageRef = FirebaseStorage
          .instance
          .ref()
          .child('users')
          .child(uid)
          .child('familyMembers')
          .child(memberId)
          .child('voice_note.m4a');

      await storageRef.putFile(file);

      final downloadUrl =
          await storageRef.getDownloadURL();

      print(
        'Voice uploaded: $downloadUrl',
      );

      return downloadUrl;
    } catch (e) {
      print(
        'Voice upload error: $e',
      );

      rethrow;
    }
  }

  // =========================
  // PLAY VOICE
  // =========================
  Future<void> playVoice(String url) async {
    try {
      if (url.isEmpty) {
        return;
      }

      await _audioPlayer.stop();

      await _audioPlayer.play(
        UrlSource(url),
      );

      print('Voice playing');
    } catch (e) {
      print(
        'Voice playback error: $e',
      );
    }
  }

  // =========================
  // STOP VOICE
  // =========================
  Future<void> stopVoice() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print(
        'Stop voice error: $e',
      );
    }
  }

  // =========================
  // CHECK RECORDING STATUS
  // =========================
  bool get isRecording => _isRecording;

  // =========================
  // DISPOSE
  // =========================
  Future<void> dispose() async {
    await _recorder.dispose();
    await _audioPlayer.dispose();
  }
}