import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../generated/l10n.dart';
class CreateCelebrityPage1 extends StatelessWidget {
  const CreateCelebrityPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.82.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
          height: 0.6.sh,
          child: Stack(
            children: [

              // Big circle overflowing top
              Positioned(
                // half the circle outside screen
                left: -0.15.sw, // shift left so it’s centered
                child: Container(
                  width: 1.26.sw, // 150% of screen width
                  height: 1.26.sw,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF4758EF).withOpacity(0.35),                 // center
                        const Color(0xFF4758EF).withOpacity(0.0) // fade out
                      ],
                      radius: 0.53,
                    ),
                  ),
                ),
              ),

              // Foreground content
              Positioned(
                top: 0,
                left: 0,
                right: 0,   // <-- Add this
                child: Container(
                  padding: EdgeInsets.only(left: 40.r,top: 50.r),
                  height: 200.h,

                  child: Text(S.of(context).createCharacterTitle,style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 60.sp
                  ),),
                ),
              ),

            ],
      )
      ),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.r),
        child: ElevatedButton(onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              maintainState: true,  // Keep previous route's state
              builder: (context) => CreateCelebrityPage2()
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand1,
          padding: EdgeInsets.symmetric(vertical: 50.r),

        )

            , child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           SvgPicture.asset('images/svg/create.svg'),
            SizedBox(
              width: 50.w,
            ),
            Text(S.of(context).createYourCharacterButton,style: TextStyle(
              fontSize: 50.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.white2
            ),)
          ],
        )),
      )
      ]
      ),
    );
  }
}
