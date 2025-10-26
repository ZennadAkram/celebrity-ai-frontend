import 'dart:io';

import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';


class CelebrityModel{
  int? id;
  String name;
  final String? avatar;
  String? description;
  final File? image;
  bool isPrivate;
  String? category;
  CelebrityModel({required this.isPrivate,this.id,this.image,this.avatar,required this.name,this.description,this.category});

  factory CelebrityModel.fromJson(Map<String,dynamic> json){
    return CelebrityModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'], isPrivate: json['is_Private'],
      category: json['category'],
      description: json['description']

    );

  }
factory CelebrityModel.fromEntity(CelebrityEntity entity){
    return CelebrityModel(
      name: entity.name,
      description: entity.description,
      image: entity.image,
      isPrivate: entity.isPrivate,
      category: entity.category
    );
  }
 CelebrityEntity toEntity(){
    return CelebrityEntity(
      name: name,
      id: id,
      imageUrl: avatar,
      isPrivate: isPrivate,
      category: category,
      description: description
    );

  }





}