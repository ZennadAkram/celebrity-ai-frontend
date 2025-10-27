import 'dart:async';

import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../domain/entities/celebrity.dart';
import '../providers/celebrity_providers.dart';
import 'character_card.dart';
class MySearchDelegate extends SearchDelegate {
  final List<String> data;

  MySearchDelegate(this.data);
  @override
  TextStyle? get searchFieldStyle => TextStyle(color: AppColors.white2);

  @override
  InputDecorationTheme get searchFieldDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.black1,

    // dark background
    hintStyle: TextStyle(color: AppColors.white2),

    contentPadding: EdgeInsets.symmetric(
      vertical: 14, // top & bottom padding
      horizontal: 10, // left & right padding
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),

      borderSide: BorderSide.none
    ) ,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),

      borderSide: BorderSide.none,
    ),
  );



  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return theme.copyWith(
      scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        backgroundColor: isDark ? Colors.black : Colors.white,
        toolbarHeight: 0.15.sw,
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: AppColors.white2,
        ),
        toolbarTextStyle: TextStyle(
          color:  AppColors.white2,
          fontSize: 18,
        ),
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.white2 : AppColors.black1,
          fontSize: 18,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.white2 ,
        selectionColor: AppColors.brand1,
        selectionHandleColor: AppColors.brand1,
      ),
      inputDecorationTheme: searchFieldDecorationTheme,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(Icons.clear),
        onPressed: () {

          query = ''; // clear the search field
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Consumer(
        builder: (context, ref, _) =>
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              query = '';
              ref.read(viewModelProvider.notifier).getCelebrities("",null);
              close(context, null); // close search
            },
          )
        );



  }

  String? _lastQuery; // add this field inside your SearchDelegate class

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(viewModelProvider.notifier);
        final state = ref.watch(viewModelProvider);

        final celebrities =
        state is AsyncData<List<CelebrityEntity>> ? state.value : null;

        // 👇 Only fetch if user typed manually (not from suggestion)
        if (query.isNotEmpty &&
            _lastQuery != query &&
            (celebrities == null || celebrities.length != 1)) {
          _lastQuery = query;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            notifier.getCelebrities(query,null);
          });
        }

        return state.when(
          data: (celebrities) {
            if (celebrities.isEmpty) {
              return const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            return SizedBox(

              height: 1.sh,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0,top: 20),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.r, vertical: 50.r),
                          child: Text(
                            'Results',
                            style: TextStyle(
                              fontSize: 60.sp,
                              color: AppColors.white2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            // 🧽 Cancel debounce immediately

                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.grey3),

                            //padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 50.r),
                          ),
                          child: Row(
                            children: [

                              Text(
                                'Filter',
                                style: TextStyle(
                                  color: AppColors.white2,
                                  fontSize: 45.sp,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              SvgPicture.asset(
                                'images/svg/filter.svg',
                                color: AppColors.white2,
                                width: 60.r,
                                height: 60.r,
                              ),

                            ],
                        ),


                        )],
                    ),
                  ),
                  Expanded(

                    child: ListView.builder(
                      itemCount: celebrities.length,
                      itemBuilder: (context, index) {
                        final celeb = celebrities[index];
                        return CharacterCard(entity: celeb);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error: $e', style: TextStyle(color: Colors.redAccent)),
          ),
        );
      },
    );
  }


  Timer? _debounce;
  String _lastFetchedQuery = '';

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final notifier = ref.read(viewModelProvider.notifier);
        final state = ref.watch(viewModelProvider);

        // ✅ Cancel and skip auto-fetch when showing results after selection
        if (query.isNotEmpty && query != _lastFetchedQuery) {
          _debounce?.cancel();

          _debounce = Timer(const Duration(milliseconds: 1200), () {
            // Only fetch if the user is still typing (not just pressed a suggestion)
            if (ModalRoute.of(context)?.isCurrent ?? true) {
              _lastFetchedQuery = query;
              notifier.getCelebrities(query,null);
            }
          });
        }

        if (query.isEmpty) {
          _debounce?.cancel();
          _lastFetchedQuery = '';
        }

        Future.microtask(() {
          if (!context.mounted) _debounce?.cancel();
        });

        return state.when(
          data: (celebrities) {
            final suggestions = query.isEmpty
                ? celebrities
                : celebrities
                .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
                .toList();

            if (celebrities.isEmpty) {
              return const Center(
                child: Text('No results found', style: TextStyle(color: Colors.white70)),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions.map((celeb) {
                  return ElevatedButton(
                    onPressed: () {
                      // 🧽 Cancel debounce immediately
                      _debounce?.cancel();
                      _lastFetchedQuery = query;

                      // Add only the selected celeb to state
                      ref.read(viewModelProvider.notifier).addCelebrity(celeb);

                      // Set query and show result
                      query = celeb.name;
                      showResults(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: celeb.name == query
                          ? AppColors.brand1
                          : AppColors.black1,
                    ),
                    child: Text(
                      celeb.name,
                      style: TextStyle(color: AppColors.white2, fontSize: 45.sp),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) =>
              Center(child: Text('Error: $e', style: TextStyle(color: Colors.redAccent))),
        );
      },
    );
  }


// ✅ Optional: ensure timer cleanup when search closes
  @override
  void close(BuildContext context, result) {
    _debounce?.cancel();
    super.close(context, result);
  }


}
