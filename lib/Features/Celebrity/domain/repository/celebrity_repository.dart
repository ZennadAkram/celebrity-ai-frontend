import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';

abstract class CelebrityRepository{
  Future<List<CelebrityEntity>> getCelebrities(String? category);
  Future<void> createCelebrity(CelebrityEntity celebrity);
  Future<void> deleteCelebrity(int id);
}