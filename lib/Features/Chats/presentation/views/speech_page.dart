import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Network/websockets.dart';
import '../../data/repository/chat_repository_impl.dart';
import '../../domain/entities/stored_message_entity.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import '../providers/stt_provider.dart';
import '../providers/tts_providers.dart';
import '../../domain/entities/message_entity.dart';

class SpeechPage extends HookConsumerWidget {
  final int celebrityId;
  final String celebrityName;
  final String celebrityImageUrl;
  final int sessionId ;
  const SpeechPage(this.celebrityId, this.celebrityName, this.celebrityImageUrl, this.sessionId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = useState(0.5.sw);
    final height = useState(0.5.sw);
    final gradient = useState(
      const LinearGradient(
        colors: [Colors.red, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    final sttState = ref.watch(speechViewModelProvider);
    final ttsState = ref.read(ttsViewModelProvider.notifier);


    final connectionState = ref.watch(
      sendSTTModelProvider.select((state) => state.connectionStatus),
    );
    final isConnected = connectionState == ConnectionStatus.connected;
    final isMicOn = sttState.isListening;

    // Debounce to avoid double sending
    Timer? _debounceTimer;

    // Connect WebSocket on mount
    useEffect(() {
      ref.read(chatRepositoryProvider).connect();
      return ref.read(chatRepositoryProvider).disconnect;;
    }, []);

    // STT & animation setup
    useEffect(() {
      final sttVM = ref.read(speechViewModelProvider.notifier);

      // Mic animation
      final animTimer = Timer(const Duration(milliseconds: 1500), () {
        width.value = 0.7.sw;
        height.value = 0.7.sw;
        gradient.value = const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      });

      // Listen for connection changes
      Timer? sttStartTimer;
      final connectionSubscription = ref.listen<bool>(
        sendSTTModelProvider.select(
              (state) => state.connectionStatus == ConnectionStatus.connected,
        ),
            (prev, current) {
          if (current == true) {
            sttStartTimer?.cancel();
            sttStartTimer = Timer(const Duration(seconds: 2), () {
              if (!sttState.isListening) {
                sttVM.startListening();
              }
            });
          } else if (current == false) {
            sttVM.stopListening();

          }
        },
      );

      // Only one send per STT result
      sttVM.setOnSpeechFinished((text) {
        if (text.trim().isEmpty) return;

        _debounceTimer?.cancel();
        _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
          await _sendMessageWithConnectionCheck(ref, text.trim(), celebrityId);
        });
      });

      return () {
        animTimer.cancel();
        sttStartTimer?.cancel();
        sttVM.stopListening();
        _debounceTimer?.cancel();
      };
    }, []);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: width.value * (1 + sttState.soundLevel * 1.2),
                height: height.value * (1 + sttState.soundLevel * 1.2),
                curve: Curves.bounceOut,
                decoration: BoxDecoration(

                  shape: BoxShape.circle,
                  image: DecorationImage(image: CachedNetworkImageProvider(celebrityImageUrl,

                  ),
                  fit: BoxFit.cover
                  )
                ),
              ),
            ),

            Positioned(
              bottom: 0.05.sh,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      final sttVM = ref.read(speechViewModelProvider.notifier);


                      if (isMicOn) {

                        sttVM.stopListening();
                        ref.read(switchMicrophoneProvider.notifier).state=false;

                      } else {
                        ref.read(switchMicrophoneProvider.notifier).state=true;
                       await ttsState.stop();
                        sttVM.startListening();
                      }
                    },
                    icon: Icon(
                      isMicOn ? Icons.mic : Icons.mic_off,
                      size: 0.08.sw,
                      color: isConnected
                          ? (isMicOn ? AppColors.white2 : Colors.redAccent)
                          : Colors.grey,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isConnected
                          ? (isMicOn ? AppColors.black1 : const Color(0xFF330000))
                          : Colors.grey,
                      padding: EdgeInsets.all(50.r),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final ttsVM = ref.read(ttsViewModelProvider.notifier);
                      ttsVM.stop();
                      ref.read(speechViewModelProvider.notifier).clearText();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      size: 0.08.sw,
                      color: AppColors.white2,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.black1,
                      padding: EdgeInsets.all(50.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessageWithConnectionCheck(WidgetRef ref, String text, int celebrityId) async {
    final chatVM = ref.read(sendSTTModelProvider.notifier);
    final connectionState = ref.read(
      sendSTTModelProvider.select((state) => state.connectionStatus),
    );

    if (connectionState != ConnectionStatus.connected) return;

    try {
      await chatVM.sendMessage(text, celebrityId);
      ref
          .read(storedMessagesViewModelProvider.notifier)
          .saveMessage(StoredMessageEntity(
          session:sessionId,
          sender: 'user',
          text:text));
    } catch (e) {
      print("❌ Error sending message: $e");
    }
  }


}
