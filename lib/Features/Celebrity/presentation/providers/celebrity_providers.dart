import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/data_source.dart';
import '../../data/repository/celebrity_repository_impl.dart';
import '../../domain/usecases/create_celebrity_use_case.dart';
import '../../domain/usecases/get_celebrities_use_case.dart';
import '../viewmodels/get_celebrities_view_model.dart';

final repositoryImplProvider=Provider<CelebrityRepositoryImpl>((ref){
  return CelebrityRepositoryImpl(DataSourceCelebrity());
});

final getCelebritiesUseCaseProvider=Provider<GetCelebrityUseCase>((ref){
  final repository=ref.watch(repositoryImplProvider);
  return GetCelebrityUseCase(repository);
});
final createCelebrityUseCaseProvider=Provider<CreateCelebrityUseCase>((ref){
  final repository=ref.watch(repositoryImplProvider);
  return CreateCelebrityUseCase(repository);
});
final viewModelProvider=StateNotifierProvider<getCelebrityViewModel,AsyncValue<List<CelebrityEntity>>>((ref){
  return getCelebrityViewModel(ref.watch(getCelebritiesUseCaseProvider), ref.watch(createCelebrityUseCaseProvider));
});

final celebrityProvider=StateProvider<CelebrityEntity>((ref)=>CelebrityEntity(isPrivate: false, name: ""));
final isPrivateProvider=StateProvider<bool>((ref)=>false);
final genderProvider=StateProvider<String?>((ref)=>null);
final categoryProvider=StateProvider<String?>((ref)=>null);