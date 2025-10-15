import 'dart:io';

class User{
  int? id;
String userName;
String? _password;
String? email;
final String? avatarUrl; // for images from backend
final File? avatarFile;
User({required this.userName,this.email,this.avatarFile,this.avatarUrl,this.id});
void setPassword(String password){
  this._password=password;
}
String? getPassword(){
  return this._password;
}
}