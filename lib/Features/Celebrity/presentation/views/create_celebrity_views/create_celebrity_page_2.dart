import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_colors.dart';
import '../../../../../Shared/Global_Widgets/chip_choice.dart';
import '../../providers/celebrity_providers.dart';
class CreateCelebrityPage2 extends ConsumerWidget {
  const CreateCelebrityPage2({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final viewModel=ref.watch(viewModelProvider.notifier);
    final viewModelChanger=ref.read(viewModelProvider.notifier);
    final private=ref.watch(isPrivateProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.black,
        body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 40.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50.r),
                  height: 200.h,
                  color: Colors.black,
                  child: Row(
                    children: [
                      BackButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                          minimumSize: WidgetStateProperty.all(Size.zero), // optional: removes min tap area
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

                        ),
                        color: AppColors.white2,
                      ),
                      SizedBox(width: 40.r,),
                      Text('Create Character',style: TextStyle(
                          color: AppColors.white2,
                          fontSize: 60.sp
                      ),),
                    ],
                  ),
                ),
                 SizedBox(height: 0.03.sh,),
                TextField(
                  style: TextStyle(
                    color: AppColors.white2
                  ),
                  cursorColor: AppColors.white2,
                  maxLines: 1,
                  controller: viewModel.nameController,
                  onChanged: (value){
                    viewModelChanger.nameController.text=value;
                  },


                  decoration: InputDecoration(
                    fillColor: AppColors.black1,
                   filled: true,
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(12),
                     borderSide: BorderSide(
                       color: AppColors.grey1
                     )
                   ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: AppColors.brand1
                        )
                    ),
                    hintText: 'Character name',
                    hintStyle: TextStyle(
                      color: AppColors.grey1
                    ),
                  ),
                ),
                SizedBox(height: 0.03.sh,),
                  ButtonTheme(
                  alignedDropdown: true, // 👈 aligns the dropdown menu and hint
                  child: DropdownButtonFormField<String>(
                  dropdownColor: AppColors.black1,
                  icon: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.grey1,
                  size: 24,
                  ),
                  style: const TextStyle(
                  color: AppColors.white2,
                  fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18), // 👈 tune this
                  fillColor: AppColors.black1,
                  filled: true,
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: AppColors.grey1),
                  ),
                  focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: AppColors.brand1),
                  ),
                  ),
                  hint: const Text(
                  'Choose gender',
                  style: TextStyle(
                  color: AppColors.grey1,
                  fontWeight: FontWeight.w600,
                  ),
                  ),
                  items: const [
                  DropdownMenuItem(
                  value: 'Male',
                  child: Text('Male'),
                  ),
                  DropdownMenuItem(
                  value: 'Female',
                  child: Text('Female'),
                  ),
                  ],
                  onChanged: (value) {
                  ref.read(genderProvider.notifier).state=value;
                  },
                  ),
                  ),
                  SizedBox(height: 0.03.sh,),
                Padding(
                  padding:  EdgeInsets.only(left: 26.r),
                  child: Text('Character info',

                    style: TextStyle(

                        color: AppColors.grey1
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh,),
                SizedBox(
                  height: 0.17.sh,
                  child: TextField(
                    style: TextStyle(

                        color: AppColors.white2
                    ),
                    cursorColor: AppColors.white2,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    controller: viewModel.descriptionController,
                    onChanged: (value){
                      viewModelChanger.descriptionController.text=value;
                    },




                    decoration: InputDecoration(
                      fillColor: AppColors.black1,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.grey1
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.brand1
                          )
                      ),
                      hintText: 'Descript your character information',
                      hintStyle: TextStyle(
                          color: AppColors.grey1
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.03.sh,),
                Padding(
                  padding:  EdgeInsets.only(left: 26.r),
                  child: Text('Greeting',

                    style: TextStyle(

                        color: AppColors.grey1
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh,),
                SizedBox(
                  height: 0.12.sh,
                  child: TextField(
                    style: TextStyle(
                        color: AppColors.white2
                    ),
                    cursorColor: AppColors.white2,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    controller: viewModel.greetingController,
                    onChanged: (value){
                      viewModelChanger.greetingController.text=value;
                    },




                    decoration: InputDecoration(
                      fillColor: AppColors.black1,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.grey1
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: AppColors.brand1
                          )
                      ),
                      hintText: 'type your greeting here',
                      hintStyle: TextStyle(
                          color: AppColors.grey1
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 0.03.sh,),
                Padding(
                  padding:  EdgeInsets.only(left: 26.r),
                  child: Text('Visibility',

                    style: TextStyle(

                        color: AppColors.grey1
                    ),
                  ),
                ),
                SizedBox(height: 0.01.sh,),

                SizedBox(
                    height: 0.045.sh,
                    child: ChipChoice(choices: ['Public','Private'], onSelected: (String value) {
                      if(value=='Private'){
                        private.state=true;
                      }else{
                        private.state=false;
                      }

                    },)),

                SizedBox(height: 0.02.sh,),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 26.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Advanced (optional)',style: TextStyle(

                          color: AppColors.white2
                      ),),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined,color: AppColors.white2,size: 20,))
                    ],
                  ),
                ),
                SizedBox(height: 0.02.sh,),


                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          maintainState: true,  // Keep previous route's state
                          builder: (context) => CreateCelebrityPage3()
                      ),
                    );

                  },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brand1,
                        padding: EdgeInsets.symmetric(vertical: 50.r),

                      )

                      , child:Text('Next',style: TextStyle(
                          fontSize: 50.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white2
                      ),)),
                ),




              ],
            ),
          ),
        ),
            ),
      );
  }
}
