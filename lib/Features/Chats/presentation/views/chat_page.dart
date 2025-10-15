import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/domain/entities/celebrity.dart';
import 'package:chat_with_charachter/Features/Chats/domain/entities/chat_session_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../Core/Network/providers/websocket_provider.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import '../widgets/message_body.dart';
import '../widgets/text_field.dart';

class ChatPage extends ConsumerStatefulWidget {
  final CelebrityEntity? entity;
  final ChatSessionEntity? entitySession;

  const ChatPage({super.key, this.entity, this.entitySession});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {

  bool _initialized = false;
  late final chatRepo = ref.read(chatRepositoryProvider);
  // Remove the chatViewModel initialization from here

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeChat();
  }

  void _initializeChat() {
    if (_initialized) return;
    _initialized = true;

    // Ensure we're mounted before proceeding
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      try {
        // First connect the WebSocket
        await chatRepo.connect();

        // Then load messages if we have a session
        if (widget.entitySession?.id != null) {
          // Use ref.read here instead of storing chatViewModel as a field
          await ref.read(chatViewModelProvider.notifier)
              .loadStoredMessages(widget.entitySession!.id!);
        }
      } catch (e, st) {
        debugPrint('Error initializing chat: $e\n$st');
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    switch (state) {
      case AppLifecycleState.paused:
        chatRepo.disconnect();
        break;
      case AppLifecycleState.resumed:
        chatRepo.connect();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    // Only cleanup if we're actually disposing
    if (mounted && ModalRoute.of(context)?.isCurrent == false) {
      WidgetsBinding.instance.removeObserver(this);
      chatRepo.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Watch providers inside build
    final storedMessages = ref.watch(storedMessagesViewModelProvider);
    final connectionStatus = ref.watch(webSocketConnectionProvider);
    final chatViewModel = ref.watch(chatViewModelProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        if (!mounted) return true;
        await chatRepo.disconnect();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // AppBar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.r, vertical: 60.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (!mounted) return;
                        await chatRepo.disconnect();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.arrow_back,
                          color: AppColors.white2, size: 80.r),
                    ),
                    Text(
                      widget.entity?.name ??
                          widget.entitySession?.celebrity_name ??
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

              // Connection Status
              if (connectionStatus.isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),

              // Messages
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: storedMessages.when(
                    data: (_) => MessagesBody(
                      widget.entitySession?.celebrity_image ??
                          widget.entity?.imageUrl ??
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
                            'Error loading messages',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 45.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () => chatViewModel.loadStoredMessages(
                                widget.entitySession!.id!
                            ),
                            child: Text(
                              'Retry',
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
                color: Colors.black,
                child: TextFieldChat(
                  widget.entity?.id ?? widget.entitySession?.celebrity ?? 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
