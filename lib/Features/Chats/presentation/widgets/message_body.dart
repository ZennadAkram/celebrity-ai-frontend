import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Shared/Enum/message_type.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import 'loading_buble.dart';
import 'message_buble_ai.dart';
import 'message_buble_user.dart';

class MessagesBody extends ConsumerStatefulWidget {
  const MessagesBody(this.url, {super.key});
  final String url;

  @override
  ConsumerState<MessagesBody> createState() => _MessagesBodyState();
}

class _MessagesBodyState extends ConsumerState<MessagesBody> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingOlder = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storedMessagesVM =
      ref.read(storedMessagesViewModelProvider.notifier);

      _scrollController.addListener(() async {
        if (!mounted) return;

        // ✅ When user scrolls to the top (since list is reversed)
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 50 &&
            !_isFetchingOlder &&
            storedMessagesVM.hasMoreMessages) {
          setState(() => _isFetchingOlder = true);

          await storedMessagesVM.loadMoreMessages(ref.read(sessionProvider));

          setState(() => _isFetchingOlder = false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);
    final messageList = ref.watch(messageListProvider);
    final isLoading = chatState.isLoading;

    return Padding(
      padding: const EdgeInsets.only( left: 22, right: 22),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: ListView.builder(
              controller: _scrollController,
              reverse:messageList.length==0 ? false:true, // newest messages at the bottom
              padding: EdgeInsets.zero,
              itemCount: messageList.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                // ✅ Typing indicator at bottom
                if (isLoading && index == 0) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TypingIndicator(),
                    ),
                  );
                }

                final msgIndex = isLoading ? index - 1 : index;
                if (msgIndex < 0 || msgIndex >= messageList.length) {
                  return const SizedBox.shrink();
                }

                final message = messageList[messageList.length - 1 - msgIndex];
                final isUser = message.type == MessageType.user;

                final bubble = isUser
                    ? MessageBableUser(message.content, message.timestamp)
                    : MessageBableAi(
                  isStreaming: message.isStreaming,
                  message: message.content,
                  time: message.timestamp,
                  url: widget.url,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 65),
                  child: Align(
                    alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: bubble,
                  ),
                );
              },
            ),
          ),


          if (_isFetchingOlder)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child:  CircularProgressIndicator(strokeWidth: 2,color: AppColors.white2,),
                ),
              ),
            ),
        ],
      ),
    );
  }
}