import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/l10n.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      margin: EdgeInsets.only(top: 50.h),
      decoration: BoxDecoration(
        color: AppColors.black1,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.explore, S.of(context).exploreTitle, 0),
          _buildNavItem(Icons.chat_bubble_outline, S.of(context).chatsTitle, 1),
          _buildCenterButton(context),
          _buildNavItem(Icons.folder_copy_outlined, S.of(context).library, 3),
          _buildNavItem(Icons.person_outline, S.of(context).profileTitle, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.brand1 : AppColors.white2,
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ?AppColors.brand1 : AppColors.grey2,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(2),
      child: Column(
        children: [
          Container(
            height: 150.h,
            width: 150.h,
            margin: EdgeInsets.only(top: 13.r),
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.gradientMixed
            ),
            child:  Icon(Icons.add, color:Colors.black, size: 40,),
          ),
          const SizedBox(height: 4),
          Text(
            S.of(context).create,
            style: TextStyle(
              color: AppColors.grey2,
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }
}
