import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Expanded(
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
            Expanded(child: TabBarView(children: [
              Center(
                child: Text(
                  "Public Library Content",
                  style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 40.sp,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Private Library Content",
                  style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 40.sp,
                  ),
                ),
              ),            ]))


            // Add more widgets for the library content here
          ],
        ),
      ),
    );
  }
}
