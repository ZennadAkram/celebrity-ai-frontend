import 'dart:async';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/repository/chat_repository_impl.dart';
import '../providers/chat_provider.dart';
import '../providers/stt_provider.dart';
import '../providers/tts_providers.dart';
import '../../domain/entities/message_entity.dart';

class SpeechPage extends HookConsumerWidget {
  const SpeechPage({super.key});

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

    final chatRepo = ref.read(chatRepositoryProvider);
    final sttVM = ref.read(sttViewModelProvider.notifier);
    final chatVM = ref.read(chatViewModelProvider.notifier);
    final ttsVM = ref.read(ttsViewModelProvider.notifier);
    final sttState = ref.watch(sttViewModelProvider);

    final isMicOn = sttState.isListening;

    // 🧠 Run once on mount
    useEffect(() {
      chatRepo.connect();

      // 🎬 Animate the circle
      final animTimer = Timer(const Duration(milliseconds: 1500), () {
        width.value = 0.7.sw;
        height.value = 0.7.sw;
        gradient.value = const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      });

      // 🎙️ Start STT after animation ends
      final sttTimer = Timer(const Duration(seconds: 10), () {
        sttVM.startListening();
      });

      // 🧏‍♂️ STT finished → send to chat
      sttVM.setOnSpeechFinished((text) {
        if (text.isNotEmpty) {
          print("🎤 Sending recognized text: $text");
          chatVM.sendMessage(text, 6);
        }
      });

      return () {
        animTimer.cancel();
        sttTimer.cancel();
        sttVM.stopListening();
      };
    }, []);

    // 👂 Listen for STT state changes → auto-send after stop
    ref.listen(sttViewModelProvider, (prev, next) async{
      if (prev?.isListening == true && next.isListening == false) {
        final text = next.recognizedText.trim();
        if (text.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500), () async{
           await chatVM.sendMessage(text, 6);
          });
        }
      }
    });

    // 🔊 Listen for AI message → auto speak
    ref.listen<List<MessageEntity>>(messageListProvider, (prev, next) {
      if (next.isEmpty) return;
      final lastMsg = next.last;

      if (lastMsg.type.name == 'ai' &&
          !lastMsg.isStreaming &&
          lastMsg.content.trim().isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 400), () {
          ttsVM.speak(lastMsg.content);
        });
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.r),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: width.value * (1 + sttState.soundLevel * 1.2),
                  height: height.value * (1 + sttState.soundLevel * 1.2),
                  curve: Curves.bounceOut,
                  decoration: BoxDecoration(
                    gradient: gradient.value,
                    shape: BoxShape.circle,
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
                      onPressed: () {
                        if (isMicOn) {
                          sttVM.stopListening();
                        } else {
                          sttVM.startListening();
                        }
                      },
                      icon: Icon(
                        isMicOn ? Icons.mic : Icons.mic_off,
                        size: 0.08.sw,
                        color:
                        isMicOn ? AppColors.white2 : Colors.redAccent,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: isMicOn
                            ? AppColors.black1
                            : const Color(0xFF330000),
                        padding: EdgeInsets.all(50.r),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ttsVM.stop(),
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
      ),
    );
  }
}
