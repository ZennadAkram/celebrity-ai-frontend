import 'dart:io';

import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Core/Domain/entities/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Core/Services/image_picker.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerWidget {
  final User user;
  const EditProfilePage(this.user, {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final _image = ref.watch(pickedImageProvider);
    final imageSelector=ref.read(pickedImageProvider.notifier);
    final  picker=PickImage();
    final viewModel=ref.watch(profileViewModelProvider.notifier);
    final viewModelEdit=ref.read(profileViewModelProvider.notifier);
    final isImageChanged=ref.watch(isImageChangedProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding( padding: EdgeInsets.symmetric(horizontal: 40.r,),child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.02.sh,),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  BackButton(
                    color: AppColors.white2,
                  ),

                  SizedBox(width: 0.02.sw,),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none, // <-- add this
                    ),
                  )

                ],
              ),
            ),
            SizedBox(height: 0.02.sh,),
            Container(
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                color: AppColors.black2,
                shape: BoxShape.circle
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  ClipOval(

                      child:!isImageChanged?
                          CachedNetworkImage(imageUrl:user.avatarUrl??"",width: 0.30.sw,height: 0.30.sw,fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(Icons.account_circle_rounded,size: 0.30.sw,color: AppColors.grey1),
                          ):
                          Image.file(_image!,width: 0.30.sw,height: 0.30.sw,fit: BoxFit.cover,)

                          ),
                  Positioned(
                      right: -15,
                      bottom: 3,

                      child: IconButton(
                       style: IconButton.styleFrom(
                         backgroundColor: AppColors.black1
                       ),
                          onPressed: () async {
                         imageSelector.state=await picker.pickImage();
                           if(imageSelector.state!=null){
                           ref.read(isImageChangedProvider.notifier).state=true;
                         }
                          }, icon: Icon(Icons.camera_alt_outlined,color: AppColors.white2,size: 50.r,)
                      )

                  )
                ],
              ),
            ),
            SizedBox(height: 0.05.sh,),
            TextFormField(
              controller: viewModel.userNameController,
              maxLines: 1,
              maxLength: 35,


              cursorColor: AppColors.white2,
              style: TextStyle(
                  color: AppColors.white2
              ),
              decoration: InputDecoration(


                  hintText: 'UserName',
                  hintStyle: TextStyle(
                      color: AppColors.white2
                  ),
                  fillColor: AppColors.black2,
                  filled: true,
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
              controller: viewModel.emailController,
              maxLines: 1,
              keyboardType: TextInputType.emailAddress, // 📱 shows email keyboard
              autofillHints: const [AutofillHints.email],
              cursorColor: AppColors.white2,
              style: TextStyle(

                  color: AppColors.white2
              ),
              decoration: InputDecoration(


                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: AppColors.white2
                  ),
                  fillColor: AppColors.black2,
                  filled: true,
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
            SizedBox(height: 0.05.sh,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 35.r,right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Content Preferences',style: TextStyle(
                      color: AppColors.white2,
                      fontSize: 40.sp
                  ),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 50.r,)),
                ],
              ),
            ),


            Expanded(child: SizedBox()),
            Padding(
              padding: EdgeInsets.only(bottom: 0.06.sh),
              child: SizedBox(

                width: double.infinity,
                height: 0.06.sh,
                child: ElevatedButton(onPressed: () async{
                  user.userName=viewModel.userNameController.text;
                  user.email=viewModel.emailController.text;
                  if(_image!=null){
                    user.avatarFile=_image;
                  }
                  await viewModelEdit.editUser(user);
                  ref.read(isImageSavedProvider.notifier).state=true;


                },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brand1
                  ), child: Text('Save Changes',style: TextStyle(
                    fontSize: 55.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white2
                ),),
                ),
              ),
            ),

          ],
        ),
        ),
      ),
    );
  }
}
