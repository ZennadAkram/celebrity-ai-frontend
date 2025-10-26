import 'package:chat_with_charachter/Core/Network/private_dio.dart';
import 'package:chat_with_charachter/Features/profile/data/models/Profile_model.dart';
import 'package:dio/dio.dart';

class ProfileDataSource{
  final Dio _dio = PrivateDio.dio;

Future<ProfileModel> getUser() async {
  try {
    final response = await _dio.get('/users/');
    return ProfileModel.fromJson(response.data.first);
  } on DioError catch (e) {
    if (e.response != null) {
      print("🔴 Fetch user failed: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Fetch user failed");
    } else {
      print("🔴 Network error: $e");
      throw Exception("Network error occurred");
    }
  } catch (e) {
    print("🔴 General error: $e");
    throw Exception("Unknown error occurred");
  }
}

Future<void> editUser(ProfileModel user) async {
  try {
    final formData = FormData.fromMap({
      "username": user.userName,
      "email": user.email,
      if (user.avatarFile != null)
        "user_avatar": await MultipartFile.fromFile(
          user.avatarFile!.path,
          filename: user.avatarFile!
              .path
              .split('/')
              .last,
        ),
    });

    final response = await _dio.patch('/users/${user.id}/',
    data: formData,
  options: Options(
  headers: {
  "Content-Type": "multipart/form-data",
  },
  ),
  );

    print("🟢 User updated successfully: ${response.data}");
  } on DioError catch (e) {
    if (e.response != null) {
      print("🔴 Update user failed: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Update user failed");
    } else {
      print("🔴 Network error: $e");
      throw Exception("Network error occurred");
    }
  } catch (e) {
    print("🔴 General error: $e");
    throw Exception("Unknown error occurred");
  }
}

Future<void> deleteUser(int id) async {
  try {
    final response = await _dio.delete('/users/$id/');
    print("🟢 User deleted successfully: ${response.data}");
  } on DioError catch (e) {
    if (e.response != null) {
      print("🔴 Delete user failed: ${e.response?.data}");
      throw Exception(e.response?.data['message'] ?? "Delete user failed");
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