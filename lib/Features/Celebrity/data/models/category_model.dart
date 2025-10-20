import 'package:chat_with_charachter/Features/Celebrity/domain/entities/category_entity.dart';

class CategoryModel{
  int id;
  String image;
  String name;
  CategoryModel({required this.id,required this.image,required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    image: json["image"],
    name: json["name"],

  );
CategoryEntity toEntity(){
  return CategoryEntity(id: id, image: image, name: name);

}
}