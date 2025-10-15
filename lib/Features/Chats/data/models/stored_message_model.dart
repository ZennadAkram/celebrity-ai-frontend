


import '../../domain/entities/stored_message_entity.dart';

class StoredMessageModel {
  final int? id;
  final int session;
  final String sender;
  final String text;
  final String? createdAt;

  StoredMessageModel({
     this.id,
    required this.session,
    required this.sender,
    required this.text,
    this.createdAt,

  });

  factory StoredMessageModel.fromJson(Map<String, dynamic> json) {
    return StoredMessageModel(
      id: json['id'],
      session: json['session'],
      sender: json['sender'],
      text: json['text'],
      createdAt: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {

      'session': session,
      'sender': sender,
      'text': text,

    };
  }
  StoredMessageEntity toEntity() {
    return StoredMessageEntity(
      id: id,
      session: session,
      sender: sender,
      text: text,
      createdAt: createdAt,
    );
  }
  factory StoredMessageModel.fromEntity(StoredMessageEntity entity) {
    return StoredMessageModel(

      session: entity.session,
      sender: entity.sender,
      text: entity.text,

    );
  }
}
