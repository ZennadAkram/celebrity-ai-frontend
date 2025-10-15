import '../viewmodels/speech_state.dart';
import '../viewmodels/speech_view_model.dart';
import 'package:flutter_riverpod/legacy.dart';
final speechViewModelProvider = StateNotifierProvider<SpeechViewModel, SpeechState>(
      (ref) => SpeechViewModel(),
);