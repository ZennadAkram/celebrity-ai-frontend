import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../generated/l10n.dart';
import '../providers/profile_provider.dart';

class PremiumPage extends ConsumerWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    List<double> planes = [9.99, 24.99, 99.99];
    List<String> months = [S.of(context).month1, S.of(context).month3, S.of(context).month12];
    final changePlan = ref.read(selectedPlaneProvider.notifier);
    final selectedPlan = ref.watch(selectedPlaneProvider);

    return Scaffold(

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.05.sh),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AppColors.white2, size: 25),
                  ),
                ),
                SizedBox(height: 0.12.sh),
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.gradientMixed
                      .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text(
                    S.of(context).sixtyOff,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 125.sp,
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh),
                Text(
                  S.of(context).premiumTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white2,
                    fontSize: 80.sp,
                  ),
                ),
                SizedBox(height: 0.01.sh),
                Text(
                  S.of(context).premiumSubtitle,
                  style: TextStyle(
                    color: AppColors.grey2,
                  ),
                ),
                SizedBox(height: 0.03.sh),

                /// Gradient Border Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: planes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => changePlan.state = index,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 30.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: selectedPlan == index
                                ? [
                              Color(0xFFF58E2E),Color(0xFF475BFF)
                            ]
                                : [
                             isDark ? AppColors.black2:Colors.white,
                              isDark ? AppColors.black2:Colors.white
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(2), // Border thickness
                        child: Container(
                          height: 0.09.sh,
                          padding: EdgeInsets.symmetric(horizontal: 50.r),
                          decoration: BoxDecoration(
                            color:isDark? AppColors.black2:AppColors.grey6,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${planes[index]}\$',
                                    style: TextStyle(
                                      fontSize: 60.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.white2,
                                    ),
                                  ),
                                  SizedBox(height: 0.01.sh),
                                  Text(
                                    months[index],
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      color: AppColors.white2,
                                    ),
                                  ),
                                ],
                              ),
                              selectedPlan == index?
                              SvgPicture.asset(

                                    'images/svg/pointergr.svg'

                              ):
                              SvgPicture.asset(


                                     'images/svg/pointer.svg',
                                color: AppColors.white2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 0.03.sh),
                 SizedBox(

                  width: double.infinity,
                  height: 0.06.sh,
                  child: ElevatedButton(onPressed: () {


                  },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand1
                    ), child: Text(S.of(context).startNow,style: TextStyle(
                        fontSize: 55.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white2
                    ),),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(onPressed: (){}, child: Text(S.of(context).termsConditions,style: TextStyle(
                    color: AppColors.white2,
                    fontSize: 40.sp
                  ),)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
