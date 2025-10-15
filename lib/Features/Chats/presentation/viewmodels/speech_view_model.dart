import 'package:chat_with_charachter/Features/Chats/presentation/viewmodels/speech_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;



class SpeechViewModel extends StateNotifier<SpeechState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  SpeechViewModel() : super(SpeechState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    _isInitialized = await _speech.initialize(
      onStatus: (status) => print("STT Status: $status"),
      onError: (error) => print("STT Error: $error"),

    );
    if (!_isInitialized) {
      print("❌ Speech recognition not available");
    }
  }

  void startListening() {
    if (!_isInitialized) return;
    if (!_speech.isListening) {
      _speech.listen(

        onResult: (result) {
          state = state.copyWith(
            recognizedText: result.recognizedWords,
          );
        },
        listenFor: Duration(seconds: 60),
        cancelOnError: false,
        onSoundLevelChange: (level) {
          // level is 0-100, normalize to 0.0 - 1.0
          state = state.copyWith(soundLevel: level / 100);
        },
      );
      state = state.copyWith(isListening: true);
    }
  }
 void cancelListening() {
    if (_speech.isListening) _speech.cancel();
    state = state.copyWith(isListening: false, soundLevel: 0, recognizedText: '');
  }
  void stopListening() {
    if (_speech.isListening) _speech.stop();
    state = state.copyWith(isListening: false, soundLevel: 0);
  }
  void clearText() {
    state = state.copyWith(recognizedText: '');
  }
}
