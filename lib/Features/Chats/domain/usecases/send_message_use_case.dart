import '../../data/repository/chat_repository_impl.dart';
import '../repository/chat_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return SendMessageUseCase(repository);
});

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<void> execute(String message,int celebrityId) async {
    return repository.sendMessage(message,celebrityId);
  }
}