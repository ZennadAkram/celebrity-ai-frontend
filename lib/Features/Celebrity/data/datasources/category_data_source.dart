import 'package:chat_with_charachter/Core/Network/private_dio.dart';
import 'package:chat_with_charachter/Features/Celebrity/data/models/category_model.dart';
import 'package:dio/dio.dart';

class CategoryDataSource{
  final Dio _dio=PrivateDio.dio;
  Future<List<CategoryModel>> getCategories()async{
    try{
      Response response=await _dio.get('/categories/');
      List<CategoryModel> categories=(response.data['results'] as List).map((e) => CategoryModel.fromJson(e)).toList();
      return categories;
    }catch(e){
      rethrow;
    }
  }

}