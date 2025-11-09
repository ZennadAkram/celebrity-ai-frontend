import 'package:chat_with_charachter/Features/Auth/domain/usecases/SignUp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


import '../../data/datasources/data_source.dart';
import '../../data/repositories/impl_repository.dart';
import '../../domain/repositories/repository.dart';
import '../../domain/usecases/SignIn_usecase.dart';
import '../viewmodels/login_view_model.dart';
import '../viewmodels/sign_up_view_model.dart';
final repositoryProvider=Provider<AuthRepository>((ref){
  return ImplRepository(DataSource());
});

final useCaseProvider=Provider<SignInUseCase>((ref){
  return SignInUseCase(ref.watch(repositoryProvider));
});

final useCaseSignUpProvider=Provider<SignUpUseCase>((ref){
  return SignUpUseCase(ref.watch(repositoryProvider));
});

final signUpViewModel=StateNotifierProvider<SignUpViewModel,AsyncValue<void>>((ref){
  return SignUpViewModel(ref.watch(useCaseSignUpProvider), ref);
});

final signInViewModel=StateNotifierProvider<LogInViewModel,AsyncValue<void>>((ref){
  return LogInViewModel(ref.watch(useCaseProvider), ref);
});








final toggleVisible=StateProvider<bool>((ref)=>false);
final toggleVisibleSignUp=StateProvider<bool>((ref)=>false);

final wrongCredentialsProvider=StateProvider<bool>((ref)=>false);
final userAlreadyExistsProvider=StateProvider<bool>((ref)=>false);
final emptyUserNameProvider=StateProvider<bool>((ref)=>false);
final emptyEmailProvider=StateProvider<bool>((ref)=>false);
final emptyPasswordProvider=StateProvider<bool>((ref)=>false);
final passwordTooShortProvider=StateProvider<bool>((ref)=>false);

