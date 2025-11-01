import 'package:chat_with_charachter/Core/Network/secure_storage.dart';
import 'package:chat_with_charachter/Features/Auth/presentation/views/Sign_In.dart'; // 👈 import your SignIn widget
import 'package:chat_with_charachter/main.dart'; // 👈 for navigatorKey
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthInterceptor extends Interceptor {
  final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the error is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      final refreshToken = await TokenStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          // Attempt token refresh
          final response = await _authDio.post(
            '/auth/token/refresh/',
            data: {'refresh': refreshToken},
          );

          final newAccessToken = response.data['access'];
          final newRefreshToken = response.data['refresh'];

          await TokenStorage.updateAccessToken(newAccessToken);
          await TokenStorage.updateRefreshToken(newRefreshToken);

          // Retry original request with new token
          final newRequest = err.requestOptions;
          newRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryDio = Dio(BaseOptions(
            baseUrl: dotenv.env['BASE_URL'] ?? "",
            headers: {'Authorization': 'Bearer $newAccessToken'},
          ));

          final retryResponse = await retryDio.fetch(newRequest);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh failed — logout and go to SignIn
          await _logoutAndNavigateToSignIn();
          return handler.reject(err);
        }
      } else {
        // No refresh token — logout and go to SignIn
        await _logoutAndNavigateToSignIn();
      }
    }

    return handler.next(err);
  }

  Future<void> _logoutAndNavigateToSignIn() async {
    await TokenStorage.deleteTokens();

    // ✅ Clear navigation stack and go to SignIn screen
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) =>  SignIn()),
          (route) => false,
    );
  }
}
