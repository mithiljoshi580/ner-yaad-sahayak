import 'package:flutter/material.dart';
import 'screens/face_detect_screen.dart';

void main() {
  runApp(const YaadSahayakApp());
}

class YaadSahayakApp extends StatelessWidget {
  const YaadSahayakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yaad Sahayak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const FaceDetectScreen(),
    );
  }
}