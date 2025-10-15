import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class Onboarding_1 extends StatelessWidget {
  const Onboarding_1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
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
                    height: 160.h,
                    color: Colors.black,
                  ),
                ),
                Positioned(
                    top: 0.07.sh,
                    right: 0,
                    child: OutlinedButton(onPressed: (){}, child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Skip',style: TextStyle(
                            color: AppColors.white2,
                            fontSize: 40.sp

                        ),),
                        SizedBox(width: 20.w,),
                        Icon(Icons.arrow_forward,
                          color: AppColors.white2,)

                      ],
                    )))




              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Boobot",
                          style: TextStyle(
                            fontSize: 100.sp,
                            fontWeight: FontWeight.bold,
                            foreground: Paint()
                              ..shader = AppColors.gradientOrange.createShader(
                                Rect.fromLTWH(0, 0, 300, 100), // gradient box
                              ),
                          ),
                        ),
                        TextSpan(

                          text: " , AI ChatBot for everyone!",

                          style: TextStyle(
                            fontSize: 100.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white2,
                          ),
                        ),
                      ],
                    ),
                    softWrap: true,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,

                  ),
                ),
                SizedBox(height: 50.h,),
                Text('Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.',
                style: TextStyle(
                  color: AppColors.white2,

                ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 180.h,),
                SizedBox(
                  width: double.infinity, // responsive width if you use ScreenUtil
                  height: 0.07.sh,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppColors.gradientBlue, // your gradient
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // let gradient show
                        shadowColor: Colors.transparent,     // remove default shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        print("Gradient background button pressed!");
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white2,
                        ),
                      ),
                    ),
                  ),
                )

              ],
            ),
          )


        ],
      ),

    );
  }
}
