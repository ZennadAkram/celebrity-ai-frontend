import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../Core/Constants/app_colors.dart';
import '../../../../Shared/Enum/message_type.dart';
import '../../../../generated/l10n.dart';
import '../../../Celebrity/domain/entities/celebrity.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../../domain/entities/chat_session_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/stored_message_entity.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import '../widgets/message_body.dart';
import '../widgets/text_field.dart';

class ChatPage extends HookConsumerWidget {

  final CelebrityEntity? entity;
  final ChatSessionEntity? entitySession;
  const ChatPage( {this.entity, this.entitySession,super.key});



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    useEffect((){
      // Initialize chat repository
      ref.read(chatRepositoryProvider).connect();
      return null;
    },[]
    );

    useEffect(() {
      // Determine the session id
      final sessionId = entity?.id ?? entitySession?.id;
      if (sessionId == null) return null;

      // Trigger loading messages once
      ref.read(storedMessagesViewModelProvider.notifier).getMessages(sessionId);


      return null;
    }, [entity, entitySession]);

    ref.listen<AsyncValue<List<StoredMessageEntity>>>(
      storedMessagesViewModelProvider,
          (previous, next) {
        if (next.hasValue) {
          final messages = next.value!;

          final converted = messages.map((e) => e.toMessageEntity()).toList();

          ref.read(messageListProvider.notifier).state = converted;

          if (kDebugMode) {
            print("✅ messageListProvider updated (${converted.length} messages)");
          }
        }
      },
    );



    final storedMessages =ref.watch(storedMessagesViewModelProvider);

    return Scaffold(

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.r, vertical: 60.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {

                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back,
                        color: AppColors.white2, size: 80.r),
                  ),
                  Text(
                   entity?.name ??
                        entitySession?.celebrity_name ??
                        "",
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white2,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_horiz,
                        color: AppColors.white2, size: 90.r),
                  ),
                ],
              ),
            ),





            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: storedMessages.when(
                  data: (_) => MessagesBody(
                    entitySession?.celebrity_image ??
                       entity?.imageUrl ??
                        "",
                  ),
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  error: (err, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                        S.of(context).errorLoadingMessages,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 45.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                              S.of(context).retryButton,
                            style: TextStyle(fontSize: 40.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

        // Input Field
            Material(
              color:isDark? Colors.black:AppColors.black1,
              child: TextFieldChat(
                entity?.id ?? entitySession?.celebrity ?? 0,entitySession?.id
              ),
            ),
          ],
        ),
      ),
    );
  }
}



