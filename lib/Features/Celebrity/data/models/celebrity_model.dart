import 'dart:io';

import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';


class CelebrityModel{
  int? id;
  String name;
  final String? avatar;
  String? description;
  final File? image;
  CelebrityModel({this.id,this.image,this.avatar,required this.name,this.description});

  factory CelebrityModel.fromJson(Map<String,dynamic> json){
    return CelebrityModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],

    );

  }
factory CelebrityModel.fromEntity(CelebrityEntity entity){
    return CelebrityModel(
      name: entity.name,
      description: entity.description,
      image: entity.image
    );
  }
 CelebrityEntity toEntity(){
    return CelebrityEntity(
      name: name,
      id: id,
      imageUrl: avatar,
    );
  }



}