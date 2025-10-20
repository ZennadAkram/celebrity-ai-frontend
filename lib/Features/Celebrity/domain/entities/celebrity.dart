import 'dart:io';

class CelebrityEntity{
int? id;
String name;
final String? imageUrl;
String? description;
final File? image;
 bool isPrivate;
 String? category;
CelebrityEntity({required this.isPrivate,this.id,this.image,this.imageUrl,required this.name,this.description,this.category});


}