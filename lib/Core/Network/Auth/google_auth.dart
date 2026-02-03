import 'dart:convert';

import 'package:chat_with_charachter/Shared/Global_Widgets/Main_App.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../public_dio.dart';
import '../secure_storage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn.instance;

Future<String?> getGoogleAccessToken() async {
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
  await googleSignIn.initialize(
    serverClientId: dotenv.env['SERVER_CLIENT_ID'],

  );
  try {
     // reset session


    print("❌❌❌❌❌❌❌❌");
    // Authenticate user (new API)
    final GoogleSignInAccount? account = await googleSignIn.authenticate(scopeHint:['email', 'profile'] );


    final GoogleSignInClientAuthorization? auth = await account?.authorizationClient
        .authorizationForScopes(['email', 'profile']);
     if(auth?.accessToken == null){
      final auth2= await account?.authorizationClient.authorizationForScopes(['email', 'profile']);
       return auth2?.accessToken;
     }
    return auth?.accessToken;
  } catch (e) {
    if (kDebugMode) print('Google sign-in error: $e');
    return null;
  }
}

Future<void> loginWithGoogleBackend() async{
  final token=await getGoogleAccessToken();
  print("❌❌❌❌❌❌❌❌❌ the token:"+token!);
  if (token == null) return;
  final Dio _dio=PublicDio.dio;
  try{
    final response=await _dio.post('/auth/google/',
      data: jsonEncode({'access_token': token}),

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
