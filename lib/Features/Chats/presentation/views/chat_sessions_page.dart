import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../providers/chat_session_provider.dart';
import '../widgets/chat_card.dart';
class ChatSessionsPage extends ConsumerWidget {
  const ChatSessionsPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final chatSessionState=ref.watch(chatSessionsViewModelProvider);
    return Padding(padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).chatsTitle,style: TextStyle(
          color: AppColors.white2,
          fontSize: 60.sp

        ),),
        SizedBox(
          height: 0.05.sh,
        ),
        chatSessionState.when(data: (sessions){
          if (kDebugMode) {
            print("👏👏👏👏👏👏👏👏 ${sessions.length}");
          }

          return Expanded(

            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30.r),
                itemCount: sessions.length,
                itemBuilder: (context,index){

                return Padding(
                  padding:  EdgeInsets.symmetric(vertical: 60.r),
                  child: ChatSessionCard(entity: sessions[index]),
                );

            }),
          );
        }, error: (e, _) => Center(child: Text(S.of(context).errorLoadingChats)
        ), loading: ()=>Center(child: CircularProgressIndicator(color: AppColors.brand1,),))


      ],
    ),
    );
  }
}
