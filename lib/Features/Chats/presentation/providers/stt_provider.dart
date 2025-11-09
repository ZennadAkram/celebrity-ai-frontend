import '../../domain/usecases/send_message_use_case.dart';
import '../viewmodels/chat_view_model.dart';
import '../viewmodels/speech_state.dart';
import '../viewmodels/speech_view_model.dart';
import 'package:flutter_riverpod/legacy.dart';
final speechViewModelProvider = StateNotifierProvider<SpeechViewModel, SpeechState>(
      (ref) => SpeechViewModel(),
);
final sttViewModelProvider = StateNotifierProvider<SpeechViewModel, SpeechState>(
      (ref) => SpeechViewModel(),
);

final sendSTTModelProvider =
StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  return ChatViewModel(
      ref.watch(sendMessageUseCaseProvider), ref,true
  );
});
