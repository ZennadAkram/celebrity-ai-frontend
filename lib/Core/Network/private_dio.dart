import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'intercepter.dart';

class PrivateDio{
  static final Dio dio=Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        
      },
    )
  )..interceptors.add(AuthInterceptor())
    ..interceptors.add(LogInterceptor(responseBody: true));
}