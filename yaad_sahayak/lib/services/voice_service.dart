import 'dart:io';

import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class VoiceService {
  final AudioRecorder _record = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  // Step 1: Recording Start
  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final dir = await getTemporaryDirectory();
      String path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(const RecordConfig(), path: path);
      print("Recording started at $path");
    }
  }

  // Step 2: Recording Stop - file ka path dega
  Future<String?> stopRecording() async {
    final path = await _record.stop();
    print("Recording stopped, file at: $path");
    return path;
  }

  // Step 3: Firebase Storage me Upload
  Future<String> saveVoiceToStorage(
    String uid,
    String memberId,
    String filePath,
  ) async {
    File file = File(filePath);

    final ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('voiceNotes')
        .child('$memberId.m4a');

    await ref.putFile(file);

    String downloadUrl = await ref.getDownloadURL();

    return downloadUrl;
  }

  // Step 4: Play Voice Note
  Future<void> playVoiceNote(String url) async {
    await _player.stop();
    await _player.play(UrlSource(url));
  }

  // Compatibility method used by family_detail_screen.dart
  Future<void> playVoice(String url) async {
    await playVoiceNote(url);
  }

  // Stop Voice Playback
  Future<void> stopPlayback() async {
    await _player.stop();
  }
}
