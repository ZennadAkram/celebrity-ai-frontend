import 'package:chat_with_charachter/Features/Auth/domain/entities/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/usecases/SignUp_usecase.dart';

class SignUpViewModel extends StateNotifier<AsyncValue<void>>{
  final SignUpUseCase _signUpUseCase;
  SignUpViewModel(this._signUpUseCase):super(const AsyncData(null));
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController username=TextEditingController();


  Future<void> signUpUser()async{
    state=const AsyncLoading();
    try{
      final user=User(
        email: email.text,
        userName: username.text,

      );
      user.setPassword(password.text);
      print("🔴🔴🔴🔴 ${user.getPassword() ?? "no password"}");
      await _signUpUseCase(user);
      state=const AsyncData(null);
    }catch(e,st){
      state=AsyncError(e,st);
    }
  }
  
  
}