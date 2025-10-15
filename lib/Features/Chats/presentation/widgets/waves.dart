import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/chat_provider.dart';
import '../providers/stt_provider.dart';
class AudioVisualizer extends ConsumerWidget {
  final double level; // 0.0 to 1.0
  final int bars;
  final int celebrityId;

  const AudioVisualizer(this.celebrityId, {super.key, required this.level, this.bars = 20});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(speechViewModelProvider.notifier);
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final messageState = ref.watch(speechViewModelProvider);
    return Container(
      height: 100,
      decoration: BoxDecoration(
      color: AppColors.grey0,
          borderRadius: BorderRadius.circular(18)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // A static widget before the bars
             IconButton(onPressed: (){
               vm.cancelListening();
             }, icon: Icon(Icons.close,size: 22,color: AppColors.grey2,),
               padding: EdgeInsets.all(15.h),
               constraints: BoxConstraints(),
               style:IconButton.styleFrom(backgroundColor: AppColors.black2) ,
             ),

              // The generated bars
              ...List.generate(bars, (index) {
                double barHeight = (level * 300).clamp(2.0, 100.0);

                return Padding(
                  padding:  EdgeInsets.symmetric(vertical: 70.r),
                  child: Container(
                    width: 4,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),

              // A static widget after the bars
              IconButton(onPressed: (){
                vm.stopListening();
                viewModel.sendMessage(messageState.recognizedText,celebrityId );
                vm.clearText();
              }, icon: Icon(Icons.arrow_upward,size: 22,color: Colors.black,),
          padding: EdgeInsets.all(15.h),
                constraints: BoxConstraints(),
                style:IconButton.styleFrom(backgroundColor: Colors.white) ,
              ),

            ],
          )

        ],
      ),
    );
  }
}
