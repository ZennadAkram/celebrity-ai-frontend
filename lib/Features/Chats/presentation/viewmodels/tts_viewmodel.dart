import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/legacy.dart';

class TTSViewModel extends StateNotifier<bool> {
  final FlutterTts _tts = FlutterTts();

  TTSViewModel() : super(false) {
    _init();
  }

  Future<void> _init() async {
    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);

    _tts.setStartHandler(() => state = true);
    _tts.setCompletionHandler(() => state = false);
    _tts.setCancelHandler(() => state = false);
  }
 bool isSpeaking=false;
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    final status = await Permission.audio.status;
    if (!status.isGranted) {
      await Permission.audio.request();
    }

    try {
      // Stop any current speech
      await _tts.stop();



      // Speak the new text and wait for it to start
      await _tts.speak(text.trim());
      isSpeaking=true;

      // 🔥 OPTIONAL: Wait a bit to ensure speech starts properly
      await Future.delayed(const Duration(milliseconds: 100));

    } catch (e) {
      print('🎙️ TTS Error: $e');
      rethrow;
    }
  }

  Future<void> stop() async {
    isSpeaking=false;
    await _tts.stop();
    state = false;
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}