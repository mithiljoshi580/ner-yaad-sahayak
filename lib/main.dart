import 'package:flutter/material.dart';
import 'voice_screen.dart';

void main() {
  runApp(const VoicePracticeApp());
}

class VoicePracticeApp extends StatelessWidget {
  const VoicePracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Practice',
      home: VoiceScreen(),
    );
  }
}