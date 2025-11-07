import '../viewmodels/tts_viewmodel.dart';

import 'package:flutter_riverpod/legacy.dart';
final ttsViewModelProvider =
StateNotifierProvider<TTSViewModel, bool>((ref) => TTSViewModel(ref));

final switchMicrophoneProvider = StateProvider<bool>((ref) =>true);
