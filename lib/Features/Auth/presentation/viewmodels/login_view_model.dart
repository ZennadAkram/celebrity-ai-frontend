import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/SignIn_usecase.dart';
import '../providers/providers.dart';

class LogInViewModel extends StateNotifier<AsyncValue<void>>{
  final SignInUseCase signIn;
  final Ref ref;

  LogInViewModel(this.signIn, this.ref):super(const AsyncData(null));
  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();

  Future<void> signInUser()async{
    state=const AsyncLoading();
    try{
     String resp=  await signIn(email.text, password.text);
     if(resp=="success") {
        ref.read(wrongCredentialsProvider.notifier).state = false;
     }else{
        ref.read(wrongCredentialsProvider.notifier).state = true;
        ref.read(emptyEmailProvider.notifier).state = false;
        ref.read(emptyPasswordProvider.notifier).state = false;
     }
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