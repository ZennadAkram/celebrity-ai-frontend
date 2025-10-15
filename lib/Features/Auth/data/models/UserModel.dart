import 'dart:io';

import 'package:chat_with_charachter/Features/Auth/domain/entities/User.dart';

class UserModel {
  int? id;
  String userName;
  String? _password;
  String? email;
  final String? avatarUrl; // for images from backend
  final File? avatarFile;

  UserModel(
      {required this.userName, this.email, this.avatarFile, this.avatarUrl,this.id});

  void setPassword(String password) {
    this._password = password;
  }

  String? getPassword() {
    return this._password;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['username'],
      email: json['email'],
      avatarUrl: json['user_avatar'],
    );
  }
factory UserModel.fromEntity(User entity){
    return UserModel(
      id: entity.id,
      userName: entity.userName,
      email: entity.email,
      avatarFile: entity.avatarFile,
    );
  }
  User toEntity(){
    return User(
      id: this.id,
      userName: this.userName,
      email: this.email,
      avatarUrl: this.avatarUrl,

    );
  }


}