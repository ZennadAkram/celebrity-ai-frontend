import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/celebrity_providers.dart';
import '../../widgets/library/library_celebrity_card.dart';
class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final celebrityState=ref.watch(viewModelProvider);
    final celebrityNotifier=ref.read(viewModelProvider.notifier);

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.03.sh,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 50.r),
            child: Text(
              'Library',
              style: TextStyle(
                color: AppColors.white2,
                fontSize: 60.sp,

              ),

            ),

          ),
          SizedBox(height: 0.03.sh,),

          TabBar(




              labelColor: AppColors.white2,
              unselectedLabelColor: AppColors.grey1,
              labelStyle: TextStyle(       // Selected tab text style
                fontSize: 50.sp,

              ),
              unselectedLabelStyle: TextStyle(  // Unselected tab text style
                fontSize: 49.sp,
                fontWeight: FontWeight.w400,
              ),
              indicatorColor: AppColors.brand1,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab, // 👈 FIXED
              dividerColor: Colors.black,
              tabs: [
            Tab(text: "Public",),
            Tab(text: 'Private',)
          ]),
          SizedBox(height: 0.05.sh,),
          Expanded(
              child: TabBarView(

                  children: [
                  celebrityState.when(data: (celebrities)=>AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeInOutCubic,
                    child: GridView.builder(
                         padding: EdgeInsets.symmetric(horizontal: 30.r),
                        itemCount: celebrityNotifier.publicCelebrities?.length,

                        itemBuilder: (context,index){
                          return LibraryCelebrityCard(entity: celebrityNotifier.publicCelebrities![index],);

                    }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                    mainAxisSpacing: 90.h,
                      crossAxisSpacing: 50.w,
                      childAspectRatio: 0.53

                    ),

                    ),
                  ),
                      error:(e,st)=>Center(
                        child: Text('Failed to load celebrities',style: TextStyle(
                          fontSize: 60.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white2

                        ),),
                      ), loading: ()=>Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white2,
                        ),
                      )),
                    celebrityState.when(data: (celebrities)=>AnimatedSwitcher(
                      duration: const Duration(milliseconds: 1000),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeInOutCubic,
                      child: GridView.builder(

                        padding: EdgeInsets.symmetric(horizontal: 30.r),
                        itemCount: celebrityNotifier.privateCelebrities?.length,

                        itemBuilder: (context,index){
                          return LibraryCelebrityCard(entity: celebrityNotifier.privateCelebrities![index],);

                        }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                          mainAxisSpacing: 90.h,
                          crossAxisSpacing: 50.w,
                          childAspectRatio: 0.53

                      ),

                      ),
                    ),
                        error:(e,st)=>Center(
                          child: Text('Failed to load celebrities',style: TextStyle(
                              fontSize: 60.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white2

                          ),),
                        ), loading: ()=>Center(
                          child: CircularProgressIndicator(
                            color: AppColors.white2,
                          ),
                        ))

                    ]
          )
          )


          // Add more widgets for the library content here
        ],
      ),
    );
  }
}
