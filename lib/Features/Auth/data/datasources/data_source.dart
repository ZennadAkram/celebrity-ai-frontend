import 'package:chat_with_charachter/Core/Network/public_dio.dart';
import 'package:chat_with_charachter/Features/Auth/data/models/UserModel.dart';
import 'package:dio/dio.dart';

import '../../../../Core/Network/secure_storage.dart';

class DataSource {
final Dio _dio=PublicDio.dio;

Future<void> SignIn(String username,String password)async{
  try{
    final response=await _dio.post('/auth/token/',data: {
      "username":username,
      "password":password
    });
    TokenStorage.saveTokens(response.data['access'], response.data['refresh']);
    print("🟢 Login successful: ${response.data}");
  }on DioError catch(e){
    if(e.response!=null){
      print("🔴 Login failed: ${e.response?.data}");
      throw Exception(e.response?.data['message']??"Login failed");
    }else{
      print("🔴 Login error: $e");
      throw Exception("Network error occurred");
    }
  }catch(e){
    print("🔴 General error: $e");
    throw Exception("Unknown error occurred");
  }
}
Future<void> signUp(UserModel user) async {
  try {
    // Build multipart body
   print("🔴🔴🔴🔴 ${user.getPassword() ?? "no password"}");
   print("🔴🔴🔴🔴 ${user.userName}");
    final formData = FormData.fromMap({
      "username": user.userName,
      "email": user.email,
      "password": user.getPassword(),
      if (user.avatarFile != null)
        "user_avatar": await MultipartFile.fromFile(
          user.avatarFile!.path,
          filename: user.avatarFile!.path.split('/').last,
        ),
    });

    // Send request
    final response = await _dio.post(
      '/users/',
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    print("🟢 Registration successful: ${response.data}");
  await SignIn(user.userName, user.getPassword()??"");
  } on DioError catch (e) {
    if (e.response != null) {
      print("🔴 Registration failed: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Registration failed");
    } else {
      print("🔴 Network error: $e");
      throw Exception("Network error occurred");
    }
  } catch (e) {
    print("🔴 General error: $e");
    throw Exception("Unknown error occurred");
  }
}

}