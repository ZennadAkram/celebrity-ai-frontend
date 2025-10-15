import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CharacterCard extends StatelessWidget {
  final CelebrityEntity entity;
  const CharacterCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        child: Container(
          width: double.infinity,
          height: 0.3.sh,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //border: Border.all(color: AppColors.black1,),
            color: AppColors.black1,
        
              image: DecorationImage(
                opacity: 0.8,
        
                image: CachedNetworkImageProvider(entity.imageUrl ?? "",
        
                ),
              filterQuality: FilterQuality.high,
                  fit: BoxFit.cover
              )
          ),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 50.r),
          child: Stack(
            children: [
              Positioned(
                  left: 0,
                  bottom: 100.h,
                  child:Text(entity.name,style: TextStyle(
                color: AppColors.white2,
                fontWeight: FontWeight.w500,
                    fontSize: 50.sp
        
              ),) ),
              Positioned(
                  left: 0,
                  bottom: 50.h,
                  child:Text("Create your character with us!",style: TextStyle(
                      color: AppColors.grey3,
        
                      fontSize: 40.sp
        
                  ),) ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
