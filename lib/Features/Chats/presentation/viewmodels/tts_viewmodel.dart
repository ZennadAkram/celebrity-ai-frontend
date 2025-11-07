import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/message_entity.dart';
import '../providers/chat_provider.dart';


class TTSViewModel extends StateNotifier<bool> {
  final FlutterTts _tts = FlutterTts();
  final Ref ref;

  String _buffer = '';
  Timer? _bufferTimer;
  String _lastSpokenMessageId = '';

  TTSViewModel(this.ref) : super(false) {
    _init();
  }

  Future<void> _init() async {
    _tts.getLanguages.then((languages) {
      print("Available languages: $languages");
    });

    await _tts.setLanguage("en-US");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5);

    _tts.setStartHandler(() => state = true);
    _tts.setCompletionHandler(() => state = false);
    _tts.setCancelHandler(() => state = false);

    // 🔥 Start listening for AI message updates
    ref.listen<List<MessageEntity>>(messageListProvider, (prev, next) {
      if (next.isEmpty) return;

      final lastMsg = next.last;

      // Only handle AI streaming messages
      if (lastMsg.type.name == 'ai' && lastMsg.isStreaming) {
        _onNewAiText(lastMsg);
      }
    });
  }

  /// 🔥 Handle streaming AI text
  void _onNewAiText(MessageEntity msg) {
    // If it's a new message, reset buffer
    if (msg.id != _lastSpokenMessageId) {
      _lastSpokenMessageId = msg.id;
      _buffer = '';
    }

    // Extract only the new part
    final newText = msg.content.substring(_buffer.length);
    if (newText.isEmpty) return;

    _buffer += newText;
    _bufferTimer?.cancel();

    // Wait for pause before speaking buffered text
    _bufferTimer = Timer(const Duration(milliseconds: 700), () async {
      final textToSpeak = _buffer.trim();
      _buffer = '';

      if (textToSpeak.isEmpty) return;

      try {
        await speak(textToSpeak);
      } catch (e) {
        print('🎙️ Error speaking: $e');
      }
    });
  }

  Future<void> speak(String text) async {
    final status = await Permission.audio.status;
    if (!status.isGranted) {
      await Permission.audio.request();
    }

    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    state = false;
  }

  @override
  void dispose() {
    _tts.stop();
    _bufferTimer?.cancel();
    super.dispose();
  }
}
