import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Shared/Global_Widgets/chip_choice.dart';
import '../../../../generated/l10n.dart';
import '../widgets/search.dart';
import '../providers/celebrity_providers.dart';
import '../widgets/character_card.dart';


class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<Explore> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Optional: infinite scroll
      _scrollController.addListener(() async{
        final viewModel = ref.read(viewModelProvider.notifier);
        if (!mounted) return;
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300
            &&
            !_isLoadingMore &&
            viewModel.hasMore &&
            viewModel.isInitialLoad == false
        ) {
          _isLoadingMore = true;
          await viewModel.loadMore("", null);
          _isLoadingMore = false;
          // Load more celebrities when near bottom

        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final celebritiesState = ref.watch(viewModelProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.r),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).exploreTitle,
                style: TextStyle(fontSize: 60.sp, color: AppColors.white2),
              ),
              IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate([
                      S.of(context).allCategory,
                      S.of(context).moviesCategory,
                      S.of(context).seriesCategory,
                      S.of(context).cartoonsCategory,
                      S.of(context).animeCategory,
                      S.of(context).documentaryCategory
                    ]),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: AppColors.white2,
                  size: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 0.03.sh),
          SizedBox(
            height: 0.055.sh,
            child: ChipChoice(
              choices: ['All', 'Movies', 'Series', 'Cartoons', 'Anime', 'Documentary'],
              onSelected: (choice) {
                if (choice != 'All') {
                  ref.read(viewModelProvider.notifier).getCelebrities(choice, null);
                } else {
                  ref.read(viewModelProvider.notifier).getCelebrities("", null);
                }
              },
            ),
          ),
          SizedBox(height: 0.03.sh),
          Expanded(
            child: celebritiesState.when(
              data: (celebrities) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: celebrities.length+1,
                  itemBuilder: (context, index) {
                    if (index < celebrities.length) {
                      return CharacterCard(entity: celebrities[index]);
                    }else{
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.r),
                        child: Center(

                          child: SizedBox(
                            height: 80.r,
                            width: 80.r,
                            child: _isLoadingMore
                                ? CircularProgressIndicator(color: AppColors.white2,
                              strokeWidth: 9.r,)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.brand1),
              ),
              error: (error, _) => Center(
                child: Text(S.of(context).failedToLoadCelebrities),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
