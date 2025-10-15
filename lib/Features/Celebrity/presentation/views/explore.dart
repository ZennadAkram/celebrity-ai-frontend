import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Shared/Global_Widgets/chip_choice.dart';
import '../widgets/search.dart';

import '../providers/celebrity_providers.dart';
import '../widgets/character_card.dart';
class Explore extends ConsumerWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final celebritiesState = ref.watch(viewModelProvider);

    return Padding(padding: EdgeInsets.symmetric(horizontal: 30.r),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Explore',style: TextStyle(
              fontSize: 60.sp,
              color: AppColors.white2
            ),),
            IconButton(onPressed: (){
              showSearch(context: context, delegate: MySearchDelegate(['All','Movies','Series','Cartoons','Anime','Documentary'],));

            }, icon: Icon(Icons.search,
              color: AppColors.white2,
            size: 30,
            ))
          ],
        ),
        SizedBox(height: 0.03.sh,),
        SizedBox(
          height: 0.05.sh,
          child: ChipChoice(
            choices: const ['All','Movies','Series','Cartoons','Anime','Documentary'],
            onSelected: (choice){
              if(choice!='All'){
                ref.read(viewModelProvider.notifier).getCelebrities(choice);
              }else{
                ref.read(viewModelProvider.notifier).getCelebrities("");
              }

            },
          ),
        ),
        SizedBox(height: 0.03.sh,),
        SizedBox(
          height: 0.7.sh,
          child:celebritiesState.when(data:(celebrities){
          return ListView.builder(
              itemCount: celebrities.length,
              itemBuilder: (context,index){
             return CharacterCard(entity: celebrities[index],);
          });
          } , error: (error, _) => Center(
            child: Text('Error: $error'),
          ), loading: ()=>Center(child: CircularProgressIndicator(color: AppColors.brand1,),)),
        )
      ],
    ),
    );
  }
}
