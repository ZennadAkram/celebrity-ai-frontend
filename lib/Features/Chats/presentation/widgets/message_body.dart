import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Shared/Enum/message_type.dart';
import '../providers/chat_provider.dart';
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


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);
    final isLoading = chatState.isLoading;
    final messages = chatState.messages;
    print('🎯 UI - Total messages: ${messages.length}');
    for (var i = 0; i < messages.length; i++) {
      print('  $i: "${messages[i].content}" (${messages[i].type})');
    }
    // 🔥 Scroll down when messages or loading state changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Column(
      children: [
        if (kDebugMode)
          ElevatedButton(
            onPressed: () {
              print('🔄 MANUAL REFRESH - State messages: ${messages.length}');
              setState(() {});
            },
            child: Text('Debug Refresh'),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 22, right: 22),
            child: ListView.builder(

              controller: _scrollController,
              padding: EdgeInsets.zero,
              itemCount: messages.length + (isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  print("🎯🎯🎯🎯🎯🎯");
                  print(messages.length);
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 65),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TypingIndicator(),
                    ),
                  );
                }

                final message = messages[index];

                Widget bubble;
                Alignment alignment;

                switch (message.type) {
                  case MessageType.user:
                    bubble =
                        MessageBableUser(message.content, message.timestamp);
                    alignment = Alignment.centerRight;
                    break;
                  case MessageType.ai:
                    bubble =
                        MessageBableAi(message: message.content, time: message.timestamp, url: widget.url,);
                    alignment = Alignment.centerLeft;
                    break;

                  default:
                    return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 65),
                  child: Align(
                    alignment: alignment,
                    child: bubble,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
