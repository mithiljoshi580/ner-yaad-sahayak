import 'package:flutter/material.dart';
import '../services/voice_service.dart';
import 'face_detect_screen.dart';

class FamilyDetailScreen extends StatefulWidget {
  final String name;
  final String relation;
  final String image;
  final String about;
  final String? voiceNoteUrl;
  final String? memberId;

  const FamilyDetailScreen({
    super.key,
    required this.name,
    required this.relation,
    required this.image,
    required this.about,
    this.voiceNoteUrl,
    this.memberId,
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
      if (widget.voiceNoteUrl != null &&
          widget.voiceNoteUrl!.isNotEmpty) {
        _voiceService.playVoice(widget.voiceNoteUrl!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            // =========================
            // PROFILE IMAGE
            // =========================
            const SizedBox(height: 25),

            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white12,
              backgroundImage:
                  widget.image.isNotEmpty
                      ? NetworkImage(widget.image)
                      : null,
              child: widget.image.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 70,
                      color: Colors.white70,
                    )
                  : null,
            ),

            const SizedBox(height: 20),

            // =========================
            // NAME
            // =========================
            Text(
              widget.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // RELATION
            // =========================
            Text(
              widget.relation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 25),

            // =========================
            // ABOUT CARD
            // =========================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF242844),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'About',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      widget.about,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // VOICE NOTE
            // =========================
            if (widget.voiceNoteUrl != null &&
                widget.voiceNoteUrl!.isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF242844),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [

                      const Icon(
                        Icons.record_voice_over,
                        color: Colors.white,
                        size: 30,
                      ),

                      const SizedBox(width: 12),

                      const Expanded(
                        child: Text(
                          'Voice Note',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 32,
                        ),
                        onPressed: () {
                          if (widget.voiceNoteUrl != null &&
                              widget.voiceNoteUrl!.isNotEmpty) {
                            _voiceService.playVoice(
                              widget.voiceNoteUrl!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 25),

            // =========================
            // VERIFY FACE BUTTON
            // =========================
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.face,
                    size: 25,
                  ),

                  label: const Text(
                    'Verify Face',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF6C3FC5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FaceDetectScreen(
                          verifyMode: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}