import 'dart:io';

import 'package:chat_with_charachter/Features/profile/data/datasources/profile_data_source.dart';

import '../../../../Core/Domain/entities/User.dart';
import '../../data/repositories/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/usecases/delete_user_use_case.dart';
import '../../domain/usecases/edit_user_use_case.dart';
import '../../domain/usecases/get_user_use_case.dart';
import '../viewmodels/profile_view_model.dart';
final repositoryImplProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(dataSource: ProfileDataSource());
});

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  final repository = ref.watch(repositoryImplProvider);
  return GetUserUseCase(repository);
});
final editUserUseCaseProvider = Provider<EditUserUseCase>((ref) {
  final repository = ref.watch(repositoryImplProvider);
  return EditUserUseCase(repository);
});
final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>((ref) {
  final repository = ref.watch(repositoryImplProvider);
  return DeleteUserUseCase(repository);
});
final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<User>>((ref) {
  final getUserUseCase = ref.watch(getUserUseCaseProvider);
  final editUserUseCase = ref.watch(editUserUseCaseProvider);
  final deleteUserUseCase = ref.watch(deleteUserUseCaseProvider);
  return ProfileViewModel(
      getUserUseCase, editUserUseCase, deleteUserUseCase);
});
final isImageChangedProvider = StateProvider<bool>((ref) {
  return false;
});
final pickedImageProvider = StateProvider<File?>((ref) => null);
final isImageSavedProvider = StateProvider<bool>((ref) {
  return false;
});

final selectedPlaneProvider=StateProvider<int>((ref)=>0);