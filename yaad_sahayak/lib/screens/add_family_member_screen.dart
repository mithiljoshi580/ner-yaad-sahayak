import 'package:flutter/material.dart';
import '../services/voice_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
  final _nameController = TextEditingController();
  final VoiceService _voiceService = VoiceService();
  
  bool isRecording = false;
  String? _voiceUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Family Member")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            SizedBox(height: 20),
            // MIC BUTTON - DAY 2 TASK
            Row(
              children: [
                IconButton(
                  icon: Icon(isRecording ? Icons.stop_circle : Icons.mic, size: 40, color: Colors.red),
                  onPressed: () async {
                    if (!isRecording) {
                      await _voiceService.startRecording();
                      setState(() => isRecording = true);
                    } else {
                      final path = await _voiceService.stopRecording();
                      final uid = FirebaseAuth.instance.currentUser!.uid;
                      final memberId = DateTime.now().millisecondsSinceEpoch.toString();
                      final url = await _voiceService.saveVoiceToStorage(uid, memberId, path!);
                      setState(() {
                        isRecording = false;
                        _voiceUrl = url;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Voice Saved!")));
                    }
                  },
                ),
                Text(isRecording ? "Recording..." : _voiceUrl != null ? "Voice Recorded ✅" : "Tap Mic to Record Voice Note"),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // yahan firestore me save karna hai with voiceNoteUrl = _voiceUrl
              }, 
              child: Text("Save Member")
            )
          ],
        ),
      ),
    );
  }
}