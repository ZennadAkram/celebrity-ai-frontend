import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PublicDio{
  static final Dio dio=Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? "",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-type':'application/json',
        'Accept':'application/json'
      }
    )
  );
}