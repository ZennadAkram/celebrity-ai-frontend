class ChatSessionEntity{
  int? id;
  int celebrity;
  String? timeStamp;
  String? celebrity_image;
  String? celebrity_name;
  ChatSessionEntity({this.id,required this.celebrity,this.timeStamp,this.celebrity_image, this.celebrity_name});
}