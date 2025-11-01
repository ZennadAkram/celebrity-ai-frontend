import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Core/Domain/entities/chat_session_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../views/chat_page.dart';
class ChatSessionCard extends StatelessWidget {
  final ChatSessionEntity entity;
  const ChatSessionCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(entity.timeStamp!);
    final now = DateTime.now();

    bool isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            maintainState: true,  // Keep previous route's state
            builder: (context) => ChatPage(
              entitySession: entity,
            ),
          ),
        );
      },



      child: SizedBox(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: entity.celebrity_image ?? "",
                fit: BoxFit.fill,
                width: 0.13.sw,
                height: 0.13.sw,
                errorWidget: (context, url, error) => Icon(Icons.broken_image_outlined),
              ),
            ),
            SizedBox(width: 40.w),
            // Make this expanded so Row inside takes full width
            Expanded(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entity.celebrity_name ?? "",
                        style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white2,
                        ),
                      ),
                      Text(
                        entity.timeStamp != null && entity.timeStamp!.isNotEmpty
                            ?  isToday
                            ? DateFormat('hh:mm a').format(date) // show time if today
                            : DateFormat('dd/MM/yyyy').format(date) // show date otherwise
                              : '',
                        style: TextStyle(color: AppColors.white2,
                        fontSize: 30.sp
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  Text('Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam.',maxLines: 1,
                  style: TextStyle(color: AppColors.grey2,
                  fontSize: 40.sp
                  ),
                  )
                  // Add more info if needed
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
