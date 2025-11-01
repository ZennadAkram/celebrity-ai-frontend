import 'package:chat_with_charachter/Core/Network/public_dio.dart';
import 'package:chat_with_charachter/Core/Network/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';

import '../../../Shared/Global_Widgets/Main_App.dart';
import '../../../main.dart';


  Future<String?> getFacebookAccessToken() async {
    final LoginResult result = await FacebookAuth.instance.login();
    print('Facebook login status: ${result.status}'); // debug
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      return accessToken.tokenString; // <-- This is what you send to your backend
    } else {
      print('Facebook login failed: ${result.status}');
      return null;
    }
  }
  Future<void> loginWithFacebookBackend() async{
    final token=await getFacebookAccessToken();
    if (token == null) return;
    final Dio _dio=PublicDio.dio;
    try{
     final response=await _dio.post('/auth/facebook/',
       data: {'access_token': token},

     );
     if (response.statusCode == 200) {
       if (kDebugMode) {
         print('Login successful: ${response.data}');
       }
       await TokenStorage.saveTokens(
           response.data['access'].toString(),   // <-- ensure string
           response.data['refresh'].toString()
       );
       final savedToken = await TokenStorage.getAccessToken();
       if (savedToken == response.data['access'].toString()) {
         if (kDebugMode) print("✅ correct storage");
         navigatorKey.currentState?.pushAndRemoveUntil(
           MaterialPageRoute(builder: (_) =>  MainApp()),
               (route) => false,
         );
       } else {
         if (kDebugMode) print("❌ failed to store");
       }


       // Save JWT or user info here
     } else {
       if (kDebugMode) {
         print('Backend login failed: ${response.data}');
       }
     }
    }catch (e){
      if (kDebugMode) {
        print('Dio error: $e');
      }
    }
  }
