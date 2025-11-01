import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Shared/Global_Widgets/Main_App.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../Core/Network/Auth/discord_auth.dart';
import '../../../../Core/Network/Auth/facebook_auth.dart';
import '../../../../Core/Network/Auth/google_auth.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../providers/providers.dart';
class SignUp extends ConsumerWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final toggle=ref.watch(toggleVisibleSignUp);
    final viewModel=ref.watch(signUpViewModel.notifier);
    return Scaffold(
        resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(

            children: [
            SizedBox(
            height: 0.73.sh,
            child: Stack(
              children: [
        
              // Big circle overflowing top
              Positioned(
              // half the circle outside screen
              left: -0.25.sw, // shift left so it’s centered
              child: Container(
                width: 1.5.sw, // 150% of screen width
                height: 1.5.sw,
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
                  left: 0,
        
                  child: BackButton( // default back arrow
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),),
                
                Positioned(
                    left: 0,
                    top: 0.15.sh,
                    child: Padding(
                      padding:EdgeInsets.only(left: 80.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                      Text(S.of(context).create,style: TextStyle(
                        fontSize: 90.sp,
                        color: AppColors.white2
                      ),),
                      Text(S.of(context).your_account,style: TextStyle(
                          fontSize: 90.sp,
                          color: AppColors.white2
                      ),),
                                      ],
                                    ),
                    )),
        
                Positioned(
                  top: 0.28.sh,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding:EdgeInsets.only(left: 80.r,right: 80.r),
                      child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: viewModel.email,
                                          maxLines: 1,
                                          keyboardType: TextInputType.emailAddress,
                                          cursorColor: AppColors.white2,
                                          style: TextStyle(
                                              color: AppColors.white2
                                          ),
                                          decoration: InputDecoration(
        
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: SvgPicture.asset('images/svg/email.svg'),
                                              ),
                                              hintText: S.of(context).email,
                                              hintStyle: TextStyle(
                                                  color: AppColors.white2
                                              ),
                                              fillColor: AppColors.black2,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
        
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: AppColors.brand1
                                                ),
        
                                              )
        
                                          ),
        
                                        ),
                                        SizedBox(height: 0.04.sh,),
                                        TextFormField(
                                          controller: viewModel.username,
                                          maxLines: 1,
                                          cursorColor: AppColors.white2,
                                          style: TextStyle(
                                              color: AppColors.white2
                                          ),
                                          decoration: InputDecoration(
        
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(0),
                                                child: Icon(Icons.account_circle_sharp)
                                              ),
                                              hintText: S.of(context).username,
                                              hintStyle: TextStyle(
                                                  color: AppColors.white2
                                              ),
                                              fillColor: AppColors.black2,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
        
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: AppColors.brand1
                                                ),
        
                                              )
        
                                          ),
        
                                        ),
                                        SizedBox(height: 0.04.sh,),
                                        TextFormField(
                                          controller: viewModel.password,
                                          obscureText: !toggle,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: AppColors.white2
                                          ),
        
        
        
                                          cursorColor: AppColors.white2,
        
                                          decoration: InputDecoration(
        
                                              suffixIcon: IconButton(onPressed: (){
                                                ref.read(toggleVisibleSignUp.notifier).state=!toggle;
                                              }, icon: Icon(!toggle?Icons.visibility_off:Icons.visibility_outlined,color: AppColors.grey1,)),
        
                                              prefixIcon: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: SvgPicture.asset('images/svg/password.svg'),
                                              ),
                                              hintText: S.of(context).password,
                                              hintStyle: TextStyle(
                                                  color: AppColors.white2
                                              ),
        
                                              fillColor: AppColors.black2,
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(12)
                                              ),
        
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide(
                                                    color: AppColors.brand1
                                                ),
        
                                              )
        
                                          ),
        
                                        ),
                                      ],
                                    ),
                    )),
               
                Positioned(
                  top: 0.62.sh,
                  right: 0,
                  left: 0,
                  child: Padding(
        
                    padding:EdgeInsets.only(left: 80.r,right: 80.r),
                    child: SizedBox(
                      width: double.infinity,
                      height: 0.06.sh,
                      child: ElevatedButton(onPressed: ()async{
                       await viewModel.signUpUser();
                      }, child: Text(S.of(context).register,style: TextStyle(
                          fontSize: 55.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white2
                      ),),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brand1
                        ),
                      ),
                    ),
                  ),
                ),
        
              ]
            )
            ),
              Container(
                width: double.infinity,

                padding:EdgeInsets.only(left: 80.r,right: 80.r),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    width: 1,
                                    color: AppColors.grey1
                                ))
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(S.of(context).or_login_with,style: TextStyle(
                            color: AppColors.white2,
                            fontSize: 40.sp
                        ),),
                        SizedBox(width: 10,),
                        Expanded(

                          child: Container(
                            height: 1,

                            decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(
                                    width: 1,
                                    color: AppColors.grey1
                                ))
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.04.sh,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          child: ElevatedButton(onPressed: () async {await loginWithGoogleBackend();}, child: Padding(
                            padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                            child: SvgPicture.asset('images/svg/google.svg'),
                          ),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                          ),
                        ),
                        SizedBox(
                          child: ElevatedButton(onPressed: () async{await loginWithDiscord();}, child: Padding(
                            padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                            child: SvgPicture.asset('images/svg/discord.svg',color: Colors.white,),
                          ),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                          ),
                        ),
                        SizedBox(
                          child: ElevatedButton(onPressed: () async{await loginWithFacebookBackend();}, child: Padding(
                            padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                            child: SvgPicture.asset('images/svg/meta.svg'),
                          ),
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 0.06.sh,),
                    Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(S.of(context).by_pressing_register_you_agree_to,style: TextStyle(
                            color: AppColors.white2,
                            fontSize: 44.sp
                        ),),
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,

                          ),

                          onPressed: (){

                          }, child: Text(S.of(context).termsConditions,style: TextStyle(
                            color: AppColors.secondary2,
                            fontSize: 44.sp,
                            fontWeight: FontWeight.w600
                        ),),)
                      ],
                    )
                  ],
                ),
              )
            ]
        ),
      )
    );
  }
}
