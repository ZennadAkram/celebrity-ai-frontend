import 'dart:io';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/create_celebrity_use_case.dart';
import '../../domain/usecases/get_celebrities_use_case.dart';
import '../providers/celebrity_providers.dart';

class getCelebrityViewModel extends StateNotifier<AsyncValue<List<CelebrityEntity>>> {
  final GetCelebrityUseCase _useCase;
  final CreateCelebrityUseCase _createUseCase;

  getCelebrityViewModel(this._useCase, this._createUseCase)
      : super(const AsyncLoading()) {
    _loadInitial();
  }


  List<CelebrityEntity>? _publicCelebrities;
  List<CelebrityEntity>? _privateCelebrities;


  bool _hasLoadedPublic = false;
  bool _hasLoadedPrivate = false;
  List<CelebrityEntity>? get publicCelebrities => _publicCelebrities;
  List<CelebrityEntity>? get privateCelebrities => _privateCelebrities;
  // Controllers for creating a new celebrity
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController greetingController = TextEditingController();
  final TextEditingController appearanceController = TextEditingController();

  /// Loads the initial data (public celebrities)
  Future<void> _loadInitial() async {
    await getCelebrities("", false);
    await getCelebrities("", true);
    await getCelebrities("", null);
    _currentPage=2;
    isInitialLoad=false;
  }

  /// Fetches celebrities with caching
  Future<void> getCelebrities(String? category, bool? isPrivate, {bool forceRefresh = false}) async {
    // --- Return cached data instantly for smooth UI ---
    /*if (!forceRefresh) {
      if (isPrivate == true && _privateCelebrities != null && _hasLoadedPrivate) {
        state = AsyncData(_privateCelebrities!);
        return;
      } else if (isPrivate == false && _publicCelebrities != null && _hasLoadedPublic) {
        state = AsyncData(_publicCelebrities!);
        return;
      }
    }*/

    // --- Otherwise fetch from backend ---
    state = const AsyncLoading();
    try {
      final result = await _useCase(category, isPrivate,page: 1);

      if (isPrivate == true) {
        _privateCelebrities = result;
        _hasLoadedPrivate = true;
        state = AsyncData(result);
        hasMorePrivate = result.length == 15;
      } else if (isPrivate == false) {
        _publicCelebrities = result;
        _hasLoadedPublic = true;
        state = AsyncData(result);
        hasMorePublic = result.length == 15;

      }else{
       state = AsyncData(result);
       hasMore = result.length == 15;
      }



    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool hasMore = true;
  bool isInitialLoad = true;
  bool hasMorePublic = true;
  bool hasMorePrivate = true;

  Future<void> loadMore(String? category, bool? isPrivate) async {
    if (_isLoadingMore) return;

    if (isPrivate == null && !hasMore) return;
    if (isPrivate == true && !hasMorePrivate) return;
    if (isPrivate == false && !hasMorePublic) return;

    _isLoadingMore = true;
    try {
      final nextCelebrities = await _useCase(category, isPrivate, page: _currentPage);

      if (nextCelebrities.isEmpty) {
        if (isPrivate == null) {
          hasMore = false;
        }
        if (isPrivate == true) {
          hasMorePrivate = false;
        }
        if (isPrivate == false) {
          hasMorePublic = false;
        }
        return;
      }

      final currentList = state.asData?.value ?? [];

      if (isPrivate == null) {
        state = AsyncData([...currentList, ...nextCelebrities]);
      }

      if (isPrivate == true) {
        _privateCelebrities = [...?_privateCelebrities, ...nextCelebrities];
        hasMorePrivate = nextCelebrities.length == 15;
        state = AsyncData(state.value ?? []);
      } else if (isPrivate == false) {
        _publicCelebrities = [...?_publicCelebrities, ...nextCelebrities];
        hasMorePublic = nextCelebrities.length == 15;
        state = AsyncData(state.value ?? []);

      }

      if (nextCelebrities.length == 15) {
        _currentPage++;
      } else {
        hasMore = false;
      }

    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }


  /// Add a newly created celebrity to the correct list
  void addCelebrity(CelebrityEntity celeb) {
    final isPrivate = celeb.isPrivate == true;

    if (isPrivate) {
      _privateCelebrities = [celeb, ...(_privateCelebrities ?? [])];
      state = AsyncData(_privateCelebrities!);
    } else {
      _publicCelebrities = [celeb, ...(_publicCelebrities ?? [])];
      state = AsyncData(_publicCelebrities!);
    }
  }

  /// Called when creating a new celebrity
  void onCreateCelebrity(WidgetRef ref, File selectedImage) {
    final gender = ref.read(genderProvider);
    final isPrivate = ref.read(isPrivateProvider);
    final category = ref.read(categoryProvider);

    final description = '''
Description: ${descriptionController.text.trim()}
Gender: $gender
Greeting: ${greetingController.text.trim()}
Appearance: ${appearanceController.text.trim()}
''';

    final celebrity = CelebrityEntity(
      name: nameController.text.trim(),
      description: description.trim(),
      isPrivate: isPrivate,
      category: category,
      image: selectedImage,
    );

    createCelebrity(celebrity);
  }

  /// Create celebrity and refresh corresponding list
  Future<void> createCelebrity(CelebrityEntity celeb) async {
    state = const AsyncLoading();
    try {
      await _createUseCase(celeb);
      addCelebrity(celeb);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }



  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    greetingController.dispose();
    appearanceController.dispose();
    super.dispose();
  }
}
