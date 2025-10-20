import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/category_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/create_celebrity_providers/category_provider.dart';
class CategoryCard extends ConsumerWidget {
  final CategoryEntity categoryEntity;
 final int index;

  const CategoryCard({super.key,required this.categoryEntity, required this.index});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final chosen=ref.watch(categorySelectProvider);
    return Container(
      width: 0.44.sw,

      padding: EdgeInsets.symmetric(horizontal: 30.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chosen == index ? AppColors.secondary1:AppColors.black2,
           width:chosen == index ? 2:1
        ),
        color: AppColors.black2,
        image: DecorationImage(image: CachedNetworkImageProvider(categoryEntity.image,),
        filterQuality: FilterQuality.high,
          onError: (exception, stackTrace) => Icon(Icons.broken_image_outlined),
          fit: BoxFit.cover
        )

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(categoryEntity.name,style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 40.sp,
            color: chosen == index ? AppColors.secondary1:AppColors.white2,

          ),)
        ],
      ),
    );
  }
}
