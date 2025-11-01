import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';

class ChatSessionModel{
  int? id;
 int celebrity;
  String? timeStamp;
  String? celebrity_image;
  String? celebrity_name;
  ChatSessionModel({this.id,required this.celebrity,this.timeStamp,this.celebrity_image,this.celebrity_name});

  factory ChatSessionModel.fromJson(Map<String,dynamic> json){
    return ChatSessionModel(
        celebrity:json['celebrity'],
        id:json['id'],
        timeStamp:json['time_stamp'],
      celebrity_image: json['celebrity_image'],
        celebrity_name:json['celebrity_name']



    );

  }
  ChatSessionEntity toEntity(){
    return ChatSessionEntity(
        id: id,
        celebrity: celebrity,
        timeStamp: timeStamp,
        celebrity_image:celebrity_image,
        celebrity_name:celebrity_name
    );
  }
}