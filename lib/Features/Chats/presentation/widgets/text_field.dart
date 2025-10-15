import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/widgets/waves.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/chat_provider.dart';
import '../providers/stt_provider.dart';
class TextFieldChat extends ConsumerWidget {
  final int celebrityId;
  const TextFieldChat(this.celebrityId, {super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final vm = ref.read(speechViewModelProvider.notifier);
    final isLoading = ref.watch(chatViewModelProvider).isLoading;
    final viewModel = ref.read(chatViewModelProvider.notifier);

    final speechState = ref.watch(speechViewModelProvider);
    final messageController = TextEditingController(text: speechState.recognizedText);
    return Container(
padding: EdgeInsets.symmetric(horizontal: 40.r),
      width: double.infinity,
     height: 0.17.sh,
      decoration: BoxDecoration(

      ),
      child: Container(
        margin:EdgeInsets.only(top: 60.r) ,
        child: Center(
           child: Row(

                 crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Align(

                   child: IconButton(onPressed: (){},style: IconButton.styleFrom(backgroundColor: AppColors.grey0) ,icon:Icon(Icons.graphic_eq_outlined,size: 30,color: Colors.white,))),
               SizedBox(width: 0.03.sw,),
               Expanded(child:speechState.isListening
                   ? Align(
                   alignment: Alignment.topCenter,
                   child: AudioVisualizer(level: speechState.soundLevel, celebrityId))
                   : TextField(
                 controller: messageController,
                 onSubmitted: (value){
                   messageController.text="";
                   viewModel.sendMessage(value, celebrityId);
                   vm.clearText();


                 },
                 cursorColor: AppColors.grey1,
                    style: TextStyle(
                      color: Colors.white
                    ),


                 decoration: InputDecoration(
                     contentPadding: const EdgeInsets.symmetric(
                       vertical: 12, // space above and below the text
                       horizontal: 16, // space on left and right
                     ),
                   filled: true,

                   fillColor: AppColors.grey0,
                   suffixIcon:  IconButton(
                     icon: Icon(
                       ref.watch(speechViewModelProvider).isListening ? Icons.mic : Icons.mic_none,
                       color: Colors.white,
                     ),
                     onPressed: () {
                       final viewModel = ref.read(speechViewModelProvider.notifier);
                       if (ref.read(speechViewModelProvider).isListening) {
                         viewModel.stopListening();
                       } else {
                         viewModel.startListening();
                       }
                     },
                   ),

                     hintText: "type your chat",
                   hintStyle: TextStyle(
                     color: Colors.white
                 ),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(100),
                     borderSide: BorderSide(
                       color: AppColors.grey1,
                       width: 0.5


                     )
                   ),
                   focusedBorder:  OutlineInputBorder(
                       borderRadius: BorderRadius.circular(100),
                       borderSide: BorderSide(
                           color:AppColors.grey1,
                           width: 0.5


                       )
                   )
                 ),
               )),
             ],
           ),
        ),
      ),
    );
  }
}
