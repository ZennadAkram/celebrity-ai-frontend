import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/usecases/SignUp_usecase.dart';
import '../providers/providers.dart';

class SignUpViewModel extends StateNotifier<AsyncValue<void>>{
  final SignUpUseCase _signUpUseCase;
  final Ref ref;
  SignUpViewModel(this._signUpUseCase, this.ref):super(const AsyncData(null));
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
     String resp= await _signUpUseCase(user);
     print("Response from sign up: ${resp}");
     if(resp.contains('A user with that username already exists')){
       ref.read(userAlreadyExistsProvider.notifier).state=true;
     }


      state=const AsyncData(null);
    }catch(e,st){
      state=AsyncError(e,st);
    }
  }
  
  
}