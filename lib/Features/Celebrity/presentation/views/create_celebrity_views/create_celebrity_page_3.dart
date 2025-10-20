import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_4.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/widgets/create_celebrity_widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Constants/app_colors.dart';
import '../../providers/celebrity_providers.dart';
import '../../providers/create_celebrity_providers/category_provider.dart' hide categoryProvider;
class CreateCelebrityPage3 extends ConsumerWidget {
  const CreateCelebrityPage3({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final viewModel=ref.watch(viewModelProvider.notifier);
    final viewModelChanger=ref.read(viewModelProvider.notifier);

    final categoriesState=ref.watch(categoryViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(padding:EdgeInsets.symmetric(horizontal: 40.r) ,
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
            Padding(
              padding:  EdgeInsets.only(left: 26.r),
              child: Row(
                children: [
                  Text('Appearance Description',

                    style: TextStyle(

                        color: AppColors.grey1
                    ),
                  ),
                  SizedBox(width: 0.05.sw,),
                  Icon(Icons.help_outline,color: AppColors.white2,)
                ],
              ),
            ),
            SizedBox(height: 0.02.sh,),
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
                controller: viewModel.appearanceController,
                onChanged: (value){
                  viewModelChanger.appearanceController.text=value;
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
                  hintText: 'type your appearance description here',
                  hintStyle: TextStyle(
                      color: AppColors.grey1
                  ),
                ),
              ),
            ),
            SizedBox(height: 0.03.sh,),
            Padding(
              padding:  EdgeInsets.only(left: 26.r),
              child: Text('Character Category',

                style: TextStyle(

                    color: AppColors.grey1
                ),
              ),
            ),
            SizedBox(height: 0.02.sh,),
           categoriesState.when(data: (categories)=>
             Expanded(
               child: GridView.builder(
                   itemCount: categories.length,


                   gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                     crossAxisSpacing: 10,
                     mainAxisSpacing: 10,
                     childAspectRatio: 4/2,
                   ),

                   itemBuilder: (context,index){

                     return GestureDetector(
                         onTap: (){ref.read(categorySelectProvider.notifier).state=index;
                           ref.read(categoryProvider.notifier).state=categories[index].name;

                           },
                         child: CategoryCard(categoryEntity: categories[index],index: index

                         ));

               }),
             )


               , error: (e,st)=>Center(child: Text(e.toString())), loading: ()=>Center(child: CircularProgressIndicator(color: AppColors.white2,),)),
            Padding(
              padding: EdgeInsets.only(bottom: 70.r),
              child: SizedBox(

                width: double.infinity,
                child: ElevatedButton(onPressed: (){ Navigator.of(context).push(
                  MaterialPageRoute(
                      maintainState: true,  // Keep previous route's state
                      builder: (context) => CreateCelebrityPage4()
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
            ),
          ],
        ),

        ),
      ),
    );
  }
}
