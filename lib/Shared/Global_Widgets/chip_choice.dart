import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/chip_choice_provider.dart';
class ChipChoice extends ConsumerWidget {
  final List<String> choices;
  final ValueChanged<String> onSelected;
  const ChipChoice({super.key, required this.choices, required this.onSelected,});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final provider=ref.watch(choiceProvider);
    return ListView.builder(
        itemCount: choices.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
        child: ElevatedButton(

          onPressed: (){
          ref.read(choiceProvider.notifier).state=index;
          onSelected(choices[index]);

        },
        style: ElevatedButton.styleFrom(
             // <— removes shadow

            backgroundColor: provider==index ? AppColors.brand1:AppColors.black1 ),
          child: Text(choices[index],style: TextStyle(
          color: AppColors.white2,
          fontSize: 45.sp
        ),),
        ),
      );
    });
  }
}
