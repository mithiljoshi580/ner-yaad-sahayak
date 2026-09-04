import 'package:flutter/material.dart';
import 'screens/face_detect_screen.dart';
import 'screens/welcome_screen.dart';

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
<<<<<<< HEAD
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
=======
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(), // Changed this line
    );
  }
}

// Keep this existing code unchanged for now
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yaad Sahayak - Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Family Mode',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Games',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Progress',
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),
          ],
>>>>>>> origin/yeshwanth-ui
        ),
      ),
      home: const FaceDetectScreen(),
    );
  }
}