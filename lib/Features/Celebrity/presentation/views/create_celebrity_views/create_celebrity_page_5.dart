import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/l10n.dart';
import '../../providers/create_celebrity_providers/avatar_select_provider.dart';
class CreateCelebrityPage5 extends ConsumerWidget {
  const CreateCelebrityPage5({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(colorSelectedProvider);
    final selectedImage=ref.watch(imageSelectorProvider);
    return Scaffold(

      body: SafeArea(child:

      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                padding: EdgeInsets.all(0.15.sw),
                width: 1.26.sw, // 150% of screen width
                height: 1.26.sw,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      selectedColor.withOpacity(0.35),                 // center
                      selectedColor.withOpacity(0) // fade out
                    ],
                    radius: 0.53,
                  ),
                ),
                child:ClipOval(

                  child: Image.file(selectedImage!,

                    height: 0.2.sw,
                    width: 0.2.sh,
                    fit: BoxFit.cover,
                  ),

                ),
              ),
            ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,   // <-- Add this
                  child: Container(
                    height: 100.h,

                  ),
                ),
          ]
          )
          ),
          Text(S.of(context).characterCreatedTitle,style: TextStyle(
            fontSize: 70.sp,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = AppColors.gradientOrange.createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),

          ),
          SizedBox(height: 0.02.sh,),
          SizedBox(
            width: 0.7.sw,
            child: Text(S.of(context).characterCreatedSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
              color: AppColors.white2,
              fontSize: 50.sp
            ),),
          ),

          SizedBox(height: 0.02.sh,),
          SizedBox(
            width: 0.4.sw,
            child: ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black1,
              padding: EdgeInsets.symmetric(vertical: 50.r)
            ) ,child:Text(S.of(context).viewOnLibrary,style: TextStyle(
              color: AppColors.white2,
              fontSize: 40.sp
            ),) ),
          )
        ],
      )
      ),
    );
  }
}
