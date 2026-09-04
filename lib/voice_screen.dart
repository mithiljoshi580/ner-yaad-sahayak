import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  late stt.SpeechToText _speech;

  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();

      if (available) {
        setState(() {
          _isListening = true;
          _text = '';
        });

        await _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
      });

      await _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Practice'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _text.isEmpty ? 'Speak something...' : _text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            const SizedBox(height: 40),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isListening
                  ? 'Listening...'
                  : 'Tap the Mic to speak',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}