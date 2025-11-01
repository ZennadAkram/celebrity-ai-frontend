import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Auth/presentation/views/Sign_Up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Core/Network/Auth/discord_auth.dart';
import '../../../../Core/Network/Auth/facebook_auth.dart';
import '../../../../Core/Network/Auth/google_auth.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../providers/providers.dart';
class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final toggle=ref.watch(toggleVisible);
    final viewModel=ref.watch(signInViewModel.notifier);
    return Scaffold(

      resizeToAvoidBottomInset: true,


      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
          Container(
            height: 160.h,
            width: double.infinity,

          ),
            Container(
              height: 0.12.sh,
              width: double.infinity,
              child: Center(
                child:SvgPicture.asset('images/svg/logo.svg',)
              ),
            ),
            Container(
            height: 0.82.sh,
              width: double.infinity,
              padding: EdgeInsets.only(top:100.r,bottom: 20.r,left: 80.r,right: 80.r),
              decoration: BoxDecoration(
                color: AppColors.black2,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24)
                )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).log_in,style: TextStyle(
                    fontSize: 90.sp,
                    color: AppColors.white2
                  ),),
                  Text(S.of(context).to_your_account,style: TextStyle(
                      fontSize: 90.sp,
                      color: AppColors.white2
                  ),),
                  SizedBox(height: 0.05.sh,),
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
                  SizedBox(height: 0.03.sh,),
                  TextFormField(
                    controller: viewModel.password,
                    obscureText: !toggle,
                    maxLines: 1,
                    keyboardType: TextInputType.visiblePassword,
                    style: TextStyle(
                      color: AppColors.white2
                    ),



                    cursorColor: AppColors.white2,

                    decoration: InputDecoration(

                      suffixIcon: IconButton(onPressed: (){
                        ref.read(toggleVisible.notifier).state=!toggle;
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
                  SizedBox(
                    height: 0.01.sh,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: (){}, child:Text(S.of(context).forgotPassword,style: TextStyle(
                      color: AppColors.secondary2
                    )),),
                  ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 0.06.sh,
                    child: ElevatedButton(onPressed: () async{
                     await viewModel.signInUser();
                    }, child: Text(S.of(context).login,style: TextStyle(
                      fontSize: 55.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white2
                    ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand1
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(

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
                        child: ElevatedButton(onPressed: ()async{await loginWithGoogleBackend();}, child: Padding(
                          padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                          child: SvgPicture.asset('images/svg/google.svg'),
                        ),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                        ),
                      ),
                      SizedBox(
                        child: ElevatedButton(onPressed: ()async {
                          await loginWithDiscord();
                        }, child: Padding(
                          padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                          child: SvgPicture.asset('images/svg/discord.svg',color: Colors.white,),
                        ),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                        ),
                      ),
                      SizedBox(
                        child: ElevatedButton(onPressed: ()async{
                         await loginWithFacebookBackend();
                        }, child: Padding(
                          padding: const EdgeInsets.only(top: 13,bottom: 13,left: 2,right: 2),
                          child: SvgPicture.asset('images/svg/meta.svg'),
                        ),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.black1),

                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 0.06.sh,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(S.of(context).dont_have_account+'',style: TextStyle(
                        color: AppColors.white2,
                        fontSize: 44.sp
                      ),),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,

                        ),

                      onPressed: (){
                        navigatorKey.currentState?.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) =>  SignUp()),
                              (route) => false,
                        );
                      }, child: Text(S.of(context).register_now,style: TextStyle(
                          color: AppColors.secondary2,
                          fontSize: 44.sp,
                        fontWeight: FontWeight.w600
                      ),),)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
