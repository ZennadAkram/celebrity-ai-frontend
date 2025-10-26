import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/profile/presentation/views/premium_page.dart';
import 'package:chat_with_charachter/Features/profile/presentation/views/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/profile_provider.dart';
import 'edit_profile_page.dart';
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final _image = ref.watch(pickedImageProvider);
    final isImageChanged=ref.watch(isImageSavedProvider);

    final userState=ref.watch(profileViewModelProvider);
    return userState.when(data:
        (user)=> SingleChildScrollView(
          child: Padding(
          
              padding: EdgeInsets.symmetric(horizontal: 40.r),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(
              height: 0.04.sh,

              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Column(

                children: [
          ClipOval(
          child:!isImageChanged? CachedNetworkImage(imageUrl:user.avatarUrl??"",width: 0.22.sw,height: 0.22.sw,fit: BoxFit.cover,
          errorWidget: (context, url, error) => Icon(Icons.account_circle_rounded,size: 0.22.sw,color: AppColors.grey1),
          ): Image.file(_image!,width: 0.22.sw,height: 0.22.sw,fit: BoxFit.cover,)
          ),
          SizedBox(height: 20.h,),
          
          Text(user.userName,style: TextStyle(
              color: AppColors.white2,
              fontWeight: FontWeight.w500,
              fontSize: 65.sp
          ),),
          
          Text('UID:${user.id}',style: TextStyle(
              color: AppColors.white2,
          
              fontSize: 35.sp
          ),),
                ],
              ),
                OutlinedButton(onPressed: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          EditProfilePage(user), // pass the user here
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0.05, 0), // from right slightly
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                }, child: Row(
          children: [
          
          
            Text("Edit Profile",style: TextStyle(color: AppColors.white2,fontSize: 50.sp),),
            SizedBox(width: 0.01.sh,),
            Icon(Icons.edit,color: AppColors.white2,size: 60.r,),
          ],
                ))
              ],
              ),
                SizedBox(height: 0.04.sh,),
                Container(
          width: double.infinity,
          height: 0.09.sh,
          padding: EdgeInsets.all(35.r),
          decoration: BoxDecoration(
                 gradient: AppColors.gradientMixed,
            borderRadius: BorderRadius.circular(12)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('images/svg/flame.svg'),
              SizedBox(width: 0.05.sw,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Character.AI Premium',style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 50.sp,
                      color: AppColors.white2
                    ),),
                    SizedBox(height: 0.01.sh,),
                    Text('Get Character.AI Premium to enjoy all the benefit!',style: TextStyle(
          
                        fontSize: 30.sp,
                        color: AppColors.white2
                    ),),
          
          
                  ],
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: IconButton(onPressed: (){
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      pageBuilder: (context, animation, secondaryAnimation) =>
                      PremiumPage(), // pass the user here
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        final slideAnimation = Tween<Offset>(
                          begin: const Offset(0.05, 0), // from right slightly
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slideAnimation,
                            child: child,
                          ),
                        );
                      },
                    ),
                  );
                }, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,)),
              )
            ],
          ),
                ),
                SizedBox(height: 0.04.sh,),
               Container(
                 width: double.infinity,
                 padding: EdgeInsets.symmetric(vertical:35.r),
                 child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.end,
               children: [
                 SvgPicture.asset('images/svg/pref.svg',height: 70.h,width: 70.h,),
                 SizedBox(width: 0.04.sw,),
                 Text('User Preferences',style: TextStyle(
                   color: AppColors.white2,
                   fontSize: 40.sp
                 ),)
               ],
             ),
             IconButton(onPressed: (){
               Navigator.push(
                 context,
                 PageRouteBuilder(
                   transitionDuration: const Duration(milliseconds: 400),
                   pageBuilder: (context, animation, secondaryAnimation) =>
                       UserPreferences(), // pass the user here
                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
                     final slideAnimation = Tween<Offset>(
                       begin: const Offset(0.05, 0), // from right slightly
                       end: Offset.zero,
                     ).animate(animation);

                     return FadeTransition(
                       opacity: animation,
                       child: SlideTransition(
                         position: slideAnimation,
                         child: child,
                       ),
                     );
                   },
                 ),
               );
             }, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
           ],
                 ),
               ),

                Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical:35.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset('images/svg/about.svg',height: 70.h,width: 70.h,),
                  SizedBox(width: 0.04.sw,),
                  Text('About Character.AI',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),)
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
            ],
          ),
                ),

                Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical:35.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset('images/svg/follow.svg',height: 70.h,width: 70.h,),
                  SizedBox(width: 0.04.sw,),
                  Text('Follow on Social Media',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),)
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
            ],
          ),
                ),

                Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical:35.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset('images/svg/terms.svg',height: 70.h,width: 70.h,),
                  SizedBox(width: 0.04.sw,),
                  Text('Term & Conditions',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),)
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
            ],
          ),
                ),

                Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical:35.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset('images/svg/privacy.svg',height: 70.h,width: 70.h,),
                  SizedBox(width: 0.04.sw,),
                  Text('Privacy Policy',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),)
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
            ],
          ),
                ),

                Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical:35.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset('images/svg/feedback.svg',height: 70.h,width: 70.h,),
                  SizedBox(width: 0.04.sw,),
                  Text('Feedback',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),)
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
            ],
          ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: (){},style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.brand1,
                      width: 0.5
                    )
                  ) ,child: Text('Logout',style: TextStyle(
                    color: AppColors.brand1,
                    fontSize: 40.sp
                  ),)),
                )
          
          
              ],
              ),
              ),
        )
        , error: (e,st)=>
      Center(child: Text("Error: $e",style: TextStyle(color: Colors.white),))

        , loading: ()=>
    Center(child: CircularProgressIndicator(color: AppColors.white2,)));

  }
}
