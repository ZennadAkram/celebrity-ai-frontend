import 'package:chat_with_charachter/Core/Network/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthInterceptor extends Interceptor{
  final Dio _authDio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ); // A
  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler) async{
    final  token =await TokenStorage.getAccessToken();
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
          // Make a refresh request
          final response = await _authDio.post(
            '/auth/token/refresh/', // ⬅️ Replace with your actual refresh endpoint
            data: {'refresh': refreshToken},
          );

          final newAccessToken = response.data['access'];
          await TokenStorage.updateAccessToken(newAccessToken);

          // Retry the original request with the new access token
          final newRequest = err.requestOptions;
          newRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await Dio().fetch(newRequest);
          return handler.resolve(retryResponse);
        } catch (e) {
          // Refresh token is invalid or request failed
          await TokenStorage.deleteTokens();
          return handler.reject(err);
        }
      }
    }

    // If not 401 or no refresh token, pass the error
    return handler.next(err);
  }
}