import 'package:chat_with_charachter/Core/Network/private_dio.dart';
import 'package:chat_with_charachter/Features/Celebrity/data/models/celebrity_model.dart';
import 'package:dio/dio.dart';

class DataSourceCelebrity{
  final Dio _dio=PrivateDio.dio;
  Future<List<CelebrityModel>> getCelebrities(String? category) async{
    try{
      final response=await _dio.get('/celebrities/',queryParameters: {
        'category_name': category,
      });
      if(response.statusCode==200){
        final List<dynamic> data=response.data["results"];
        final celebrities=data.map((e) => CelebrityModel.fromJson(e)).toList();
        return celebrities;
      }else{
        throw Exception('Failed to load celebrities');
      }
    }catch(e){
      rethrow;
    }
  }
  Future<void> createCelebrity(CelebrityModel celebrity) async{
    try{
      final formData=FormData.fromMap({
        "name":celebrity.name,
        "description":celebrity.description,
        "is_Private":celebrity.isPrivate,
        "category":celebrity.category,
        "avatar":await MultipartFile.fromFile(
          celebrity.image!.path,
          filename: celebrity.image!.path.split('/').last
        )
      });
      final response=await _dio.post('/celebrities/',data: formData);
      if(response.statusCode!=201){
        throw Exception('Failed to create celebrity');
      }
    }catch(e){
      rethrow;
    }
  }
}