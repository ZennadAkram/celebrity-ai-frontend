import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';
import '../providers/chat_session_provider.dart';
import '../widgets/chat_card.dart';
import 'chat_page.dart';

class ChatSessionsPage extends ConsumerStatefulWidget {
  const ChatSessionsPage({super.key});

  @override
  ConsumerState<ChatSessionsPage> createState() => _ChatSessionsPageState();
}

class _ChatSessionsPageState extends ConsumerState<ChatSessionsPage> {
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(() async {
        if (!mounted) return;
        final viewModel = ref.read(chatSessionsViewModelProvider.notifier);

        final position = _scrollController.position;
        if (position.pixels >= position.maxScrollExtent - 300 &&
            !_isLoadingMore &&
            viewModel.hasMore &&
            viewModel.isInitialLoad == false
          ) { // optional flag from viewmodel
          _isLoadingMore = true;
          await viewModel.loadMore();
          _isLoadingMore = false;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final chatSessionState = ref.watch(chatSessionsViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).chatsTitle,
            style: TextStyle(
              color: AppColors.white2,
              fontSize: 60.sp,
            ),
          ),
          SizedBox(height: 0.05.sh),

          // 👇 Display chat sessions list
          chatSessionState.when(
            data: (sessions) {
              if (kDebugMode) print("✅ Sessions loaded: ${sessions.length}");

              return Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 30.r),
                  itemCount: sessions.length + 1, // always add 1 for loader placeholder
                  itemBuilder: (context, index) {
                    if (index < sessions.length) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 60.r),
                        child: GestureDetector(

                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    maintainState: true,  // Keep previous route's state
                                    builder: (context) => ChatPage(
                                      entitySession: sessions[index],
                                    ),
                                  ),
                                );
                              },

                              onLongPress: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: AppColors.black1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(

                                            leading: Icon(Icons.delete, color: Colors.red),
                                            title: Text('Delete', style: TextStyle(color: Colors.red)),
                                            onTap: () {
                                              Navigator.pop(context);
                                              ref.read(chatSessionsViewModelProvider.notifier).deleteSession(index,sessions[index].id!);


                                            },
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },

                              child: ChatSessionCard(entity: sessions[index])),
                      );
                    } else {
                      // This is the bottom loader
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.r),
                        child: Center(

                          child: SizedBox(
                            height: 80.r,
                            width: 80.r,
                            child: _isLoadingMore
                                ? CircularProgressIndicator(color: AppColors.white2,
                            strokeWidth: 9.r,)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              );

            },
            error: (e, _) => Expanded(
              child: Center(
                child: Text(S.of(context).errorLoadingChats),
              ),
            ),
            loading: () => Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.white2),
              ),
            ),
          ),

        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }
}
