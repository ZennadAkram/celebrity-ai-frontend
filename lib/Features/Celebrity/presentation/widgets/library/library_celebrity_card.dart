import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LibraryCelebrityCard extends StatelessWidget {
  final CelebrityEntity entity;
  const LibraryCelebrityCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
         width: double.infinity,
          height: 0.25.sh,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: CachedNetworkImageProvider(
              entity.imageUrl!
            ),
            fit: BoxFit.cover,
              onError:(exception, stackTrace) => Icons.broken_image_outlined,
              filterQuality: FilterQuality.high
            )

          ),
        ),
        SizedBox(height: 0.02.sh,),
        Text(entity.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          color: AppColors.white2,
          fontWeight: FontWeight.w500,
          fontSize: 50.sp
        ),),
        SizedBox(height: 0.01.sh,),
        Text(entity.description!,style: TextStyle(
          fontSize: 35.sp,
          color:AppColors.grey2
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,

        )
      ],
    );
  }
}
