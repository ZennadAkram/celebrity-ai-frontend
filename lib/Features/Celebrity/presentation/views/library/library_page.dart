import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../generated/l10n.dart';
import '../../providers/celebrity_providers.dart';
import '../../widgets/library/library_celebrity_card.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _publicScrollController = ScrollController();
  final ScrollController _privateScrollController = ScrollController();

  bool _isLoadingMorePublic = false;
  bool _isLoadingMorePrivate = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(viewModelProvider.notifier);

      // Public scroll listener
      _publicScrollController.addListener(() async {
        if (!mounted) return;
        if (_publicScrollController.position.pixels >=
            _publicScrollController.position.maxScrollExtent - 300 &&
            !_isLoadingMorePublic &&
            viewModel.hasMorePublic &&
            !viewModel.isInitialLoad) {
          setState(() => _isLoadingMorePublic = true);
          await viewModel.loadMore("", false);
          setState(() => _isLoadingMorePublic = false);
        }
      });

      // Private scroll listener
      _privateScrollController.addListener(() async {
        if (!mounted) return;
        if (_privateScrollController.position.pixels >=
            _privateScrollController.position.maxScrollExtent - 300 &&
            !_isLoadingMorePrivate &&
            viewModel.hasMorePrivate&&
            !viewModel.isInitialLoad) {
          setState(() => _isLoadingMorePrivate = true);
          await viewModel.loadMore("", true);
          setState(() => _isLoadingMorePrivate = false);
        }
      });
    });
  }

  @override
  void dispose() {
    _publicScrollController.dispose();
    _privateScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final celebrityState = ref.watch(viewModelProvider);
    final celebrityNotifier = ref.read(viewModelProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.03.sh),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.r),
            child: Text(
              S.of(context).library,
              style: TextStyle(
                color: AppColors.white2,
                fontSize: 60.sp,
              ),
            ),
          ),
          SizedBox(height: 0.03.sh),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.white2,
            unselectedLabelColor: AppColors.grey1,
            labelStyle: TextStyle(fontSize: 50.sp),
            unselectedLabelStyle: TextStyle(
              fontSize: 49.sp,
              fontWeight: FontWeight.w400,
            ),
            indicatorColor: AppColors.brand1,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: S.of(context).publicTab),
              Tab(text: S.of(context).privateTab),
            ],
          ),
          SizedBox(height: 0.05.sh),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ===================== PUBLIC TAB =====================
                celebrityState.when(
                  data: (_) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeInOutCubic,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 80.r),
                          child: GridView.builder(
                            controller: _publicScrollController,
                            key: const ValueKey('publicGrid'),
                            padding: EdgeInsets.symmetric(horizontal: 30.r),
                            itemCount:
                            celebrityNotifier.publicCelebrities?.length ?? 0,
                            itemBuilder: (context, index) {
                              return LibraryCelebrityCard(
                                entity: celebrityNotifier.publicCelebrities![index],
                              );
                            },
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 90.h,
                              crossAxisSpacing: 50.w,
                              childAspectRatio: 0.53,
                            ),
                          ),
                        ),

                        // 👇 Loader appears at bottom
                        if (_isLoadingMorePublic)
                          Positioned(
                            bottom: 30.r,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SizedBox(
                                height: 80.r,
                                width: 80.r,
                                child: CircularProgressIndicator(
                                  color: AppColors.white2,
                                  strokeWidth: 9.r,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  error: (e, st) => _buildError(context),
                  loading: () => _buildLoading(context),
                ),

                // ===================== PRIVATE TAB =====================
                celebrityState.when(
                  data: (_) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeInOutCubic,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 80.r),
                          child: GridView.builder(
                            controller: _privateScrollController,
                            key: const ValueKey('privateGrid'),
                            padding: EdgeInsets.symmetric(horizontal: 30.r),
                            itemCount:
                            celebrityNotifier.privateCelebrities?.length ?? 0,
                            itemBuilder: (context, index) {
                              return LibraryCelebrityCard(
                                entity: celebrityNotifier.privateCelebrities![index],
                              );
                            },
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 90.h,
                              crossAxisSpacing: 50.w,
                              childAspectRatio: 0.53,
                            ),
                          ),
                        ),


                        // 👇 Loader appears at bottom
                        if (_isLoadingMorePrivate)
                          Positioned(
                            bottom: 0.r,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: SizedBox(
                                height: 80.r,
                                width: 80.r,
                                child: CircularProgressIndicator(
                                  color: AppColors.white2,
                                  strokeWidth: 9.r,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  error: (e, st) => _buildError(context),
                  loading: () => _buildLoading(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Helper Widgets
  Widget _buildLoading(BuildContext context) => Center(
    child: CircularProgressIndicator(color: AppColors.white2),
  );

  Widget _buildError(BuildContext context) => Center(
    child: Text(
      S.of(context).failedToLoadCelebrities,
      style: TextStyle(
        fontSize: 60.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.white2,
      ),
    ),
  );
}
