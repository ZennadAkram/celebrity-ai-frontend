import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:chat_with_charachter/Features/profile/domain/usecases/delete_user_use_case.dart';
import 'package:chat_with_charachter/Features/profile/domain/usecases/edit_user_use_case.dart';
import 'package:chat_with_charachter/Features/profile/domain/usecases/get_user_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class ProfileViewModel extends StateNotifier<AsyncValue<User>>{
  final GetUserUseCase _getUserUseCase;
  final EditUserUseCase _editUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  ProfileViewModel(this._getUserUseCase, this._editUserUseCase, this._deleteUserUseCase):super(const AsyncLoading()){
   loadUser();
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();


  Future<void> loadUser() async{
    try{
      state=const AsyncLoading();
      final user=await _getUserUseCase();

      state=AsyncData(user);
      userNameController.text=user.userName;
      emailController.text=user.email!;
    }catch(e,st){
      state=AsyncError(e,st);
    }
  }
  Future<void> editUser(User user) async{
    try{
      state=const AsyncLoading();
      await _editUserUseCase(user);

      state=AsyncData(user);
    }catch(e,st){
      state=AsyncError(e,st);
    }
  }
  Future<void> deleteUser(int id) async {
    try {
      state = const AsyncLoading();
      await _deleteUserUseCase(id);

    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

@override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();


    super.dispose();
  }
}