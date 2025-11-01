import '../../Network/private_dio.dart';
import '../models/chat_session_model.dart';
import 'package:dio/dio.dart';

class ChatSessionsSources {
  final Dio _dio = PrivateDio.dio;

  Future<ChatSessionModel> createChatSessions(int celebrityId) async {
    try {
      final response = await _dio.post('/chats/', data: {
        'celebrity': celebrityId,
      });
      if (response.statusCode == 201) {
        return ChatSessionModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load chat sessions');
      }
    } catch (e) {
      throw Exception('Failed to load chat sessions: $e');
    }
  }
}