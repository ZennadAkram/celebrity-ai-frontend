import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/SignIn_usecase.dart';

class LogInViewModel extends StateNotifier<AsyncValue<void>>{
  final SignInUseCase signIn;

  LogInViewModel(this.signIn):super(const AsyncData(null));
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();

  Future<void> signInUser()async{
    state=const AsyncLoading();
    try{
      await signIn(email.text, password.text);
      state=const AsyncData(null);
    }catch(e,st){
      state=AsyncError(e,st);
    }
  }
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }




}