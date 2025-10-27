import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Shared/Global_Widgets/chip_choice.dart';
import '../../../../generated/l10n.dart';
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
            Text(S.of(context).exploreTitle,style: TextStyle(
              fontSize: 60.sp,
              color: AppColors.white2
            ),),
            IconButton(onPressed: (){
              showSearch(context: context, delegate: MySearchDelegate([S.of(context).allCategory,S.of(context).moviesCategory,S.of(context).seriesCategory,S.of(context).cartoonsCategory,S.of(context).animeCategory,S.of(context).documentaryCategory],));

            }, icon: Icon(Icons.search,
              color: AppColors.white2,
            size: 30,
            ))
          ],
        ),
        SizedBox(height: 0.03.sh,),
        SizedBox(
          height: 0.055.sh,
          child: ChipChoice(
            choices: ['All','Movies','Series','Cartoons','Anime','Documentary'],
            onSelected: (choice){
              if(choice!='All'){
                ref.read(viewModelProvider.notifier).getCelebrities(choice,null);
              }else{
                ref.read(viewModelProvider.notifier).getCelebrities("",null);
              }

            },
          ),
        ),
        SizedBox(height: 0.03.sh,),
        Expanded(

          child:celebritiesState.when(data:(celebrities){
          return ListView.builder(
              itemCount: celebrities.length,
              itemBuilder: (context,index){
             return CharacterCard(entity: celebrities[index],);
          });
          } , error: (error, _) => Center(
            child: Text(S.of(context).failedToLoadCelebrities),
          ), loading: ()=>Center(child: CircularProgressIndicator(color: AppColors.brand1,),)),
        )
      ],
    ),
    );
  }
}
