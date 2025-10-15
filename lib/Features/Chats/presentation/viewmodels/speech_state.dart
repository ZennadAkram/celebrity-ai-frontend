class SpeechState {
  final bool isListening;
  final String recognizedText;
  final double soundLevel; // 0.0 to 1.0

  SpeechState({this.isListening = false, this.recognizedText = '', this.soundLevel = 0});

  SpeechState copyWith({bool? isListening, String? recognizedText, double? soundLevel}) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      soundLevel: soundLevel ?? this.soundLevel,
    );
  }
}
