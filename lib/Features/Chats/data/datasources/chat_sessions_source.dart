import 'package:chat_with_charachter/Core/Network/private_dio.dart';
import 'package:chat_with_charachter/Features/Chats/data/models/chat_session_model.dart';
import 'package:chat_with_charachter/Features/Chats/data/models/stored_message_model.dart';
import 'package:dio/dio.dart';

class ChatSessionsSource{
  final Dio _dio=PrivateDio.dio;
  Future<List<ChatSessionModel>> getChatSessions()async{
    try{
      final response=await _dio.get('/chats/',queryParameters: {
        'ordering':'-time_stamp'
      });
      if(response.statusCode==200){
        List<dynamic> data=response.data['results'];
        return data.map((e) => ChatSessionModel.fromJson(e)).toList();
      }else{
        throw Exception('Failed to load chat sessions');
      }
    }catch(e){
      throw Exception('Failed to load chat sessions: $e');
    }

  }
Future<List<StoredMessageModel>> getMessagesForSession(int sessionId)async{
    try{
      final response=await _dio.get('/messages/',queryParameters: {
        'session':sessionId,
        'ordering':'-created_at'
      });
      if(response.statusCode==200){
        List<dynamic> data=response.data['results'];
        return data.map((e) => StoredMessageModel.fromJson(e)).toList();
      }else{
        throw Exception('Failed to load messages');
      }
    }catch(e){
      throw Exception('Failed to load messages: $e');
    }

  }
  Future<void> saveMessage(StoredMessageModel message)async{
    try{
      final response=await _dio.post('/messages/',data: message.toJson());
      if(response.statusCode==201){
        return;
      }else{
        throw Exception('Failed to save message');
      }
    }catch(e){
      throw Exception('Failed to save message: $e');
    }

  }

}