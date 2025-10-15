import 'dart:io';

class CelebrityEntity{
int? id;
String name;
final String? imageUrl;
String? description;
final File? image;
CelebrityEntity({this.id,this.image,this.imageUrl,required this.name,this.description});


}