import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/stored_message_entity.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_session_provider.dart';
import '../providers/stt_provider.dart';
class AudioVisualizer extends ConsumerStatefulWidget {
  final double level; // 0.0 to 1.0
  final int bars;
  final int celebrityId;
  final int sessionId;

  const AudioVisualizer(this.celebrityId, this.sessionId, {super.key, required this.level, this.bars = 20});

  @override
  ConsumerState<AudioVisualizer> createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends ConsumerState<AudioVisualizer> {
  late List<double> barHeights;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    // Start with all bars at minimum height
    barHeights = List.generate(widget.bars, (_) => 2.0);
  }

  @override
  void didUpdateWidget(covariant AudioVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Start the animation loop only when level becomes > 0
    if (!isRunning && widget.level > 0) {
      isRunning = true;
      _startWaveLoop();
    }
  }

  void _startWaveLoop() async {
    while (mounted && isRunning) {
      await Future.delayed(Duration(milliseconds: 150));

      setState(() {
        // Shift bars to the left
        for (int i = 0; i < barHeights.length - 1; i++) {
          barHeights[i] = barHeights[i + 1];
        }

        // Add the new bar at the end
        barHeights[barHeights.length - 1] =
            (widget.level * 400).clamp(2.0, 100.0);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final vm = ref.read(speechViewModelProvider.notifier);
    final viewModel = ref.read(chatViewModelProvider.notifier);
    final messageState = ref.watch(speechViewModelProvider);

    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: AppColors.grey0, borderRadius: BorderRadius.circular(18)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => vm.cancelListening(),
                icon: Icon(Icons.close, size: 22, color: AppColors.grey2),
                padding: EdgeInsets.all(15.h),
                constraints: BoxConstraints(),
                style:
                IconButton.styleFrom(backgroundColor: AppColors.black2),
              ),

              // Wave bars
              ...barHeights.map((barHeight) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: 4,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }).toList(),

              IconButton(
                onPressed: () {
                  vm.stopListening();
                  viewModel.sendMessage(
                      messageState.recognizedText, widget.celebrityId);
                  ref
                      .read(storedMessagesViewModelProvider.notifier)
                      .saveMessage(StoredMessageEntity(
                      session: widget.sessionId,
                      sender: 'user',
                      text: messageState.recognizedText));
                  vm.clearText();
                },
                icon: Icon(Icons.arrow_upward, size: 22, color: Colors.black),
                padding: EdgeInsets.all(15.h),
                constraints: BoxConstraints(),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
