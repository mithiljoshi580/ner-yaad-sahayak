import 'package:flutter/material.dart';
import '../services/voice_service.dart';

class FamilyDetailScreen extends StatefulWidget {
  final String name;
  final String relation;
  final String image;
  final String about;
  final String? voiceNoteUrl;

  const FamilyDetailScreen({
    super.key,
    required this.name,
    required this.relation,
    required this.image,
    required this.about,
    this.voiceNoteUrl,
  });

  @override
  State<FamilyDetailScreen> createState() => _FamilyDetailScreenState();
}

class _FamilyDetailScreenState extends State<FamilyDetailScreen> {
  final VoiceService _voiceService = VoiceService();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (widget.voiceNoteUrl != null) {
        _voiceService.playVoice(widget.voiceNoteUrl!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> memories = [
      'https://images.unsplash.com/photo-1511895426328-dc8714191300',
      'https://images.unsplash.com/photo-1504159066876-f838247a1a4e',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF181A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2238),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Family Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // yahan se tera baki ka purana UI code waise hi rahega
            // ...
            // jahan image / name dikha raha hai wahan ye button add kar dena
            IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.white, size: 32),
              onPressed: () {
                if (widget.voiceNoteUrl != null) {
                  _voiceService.playVoice(widget.voiceNoteUrl!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}