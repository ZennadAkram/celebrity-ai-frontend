import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/widgets/triangle_ai.dart';
import 'package:flutter/material.dart';

class MessageBableAi extends StatefulWidget {
  const MessageBableAi({
    super.key,
    required this.message,
    required this.time,
    required this.url,
    required this.isStreaming,
  });

  final String message;
  final DateTime time;
  final String url;
  final bool isStreaming;

  @override
  State<MessageBableAi> createState() => _MessageBableAiState();
}

class _MessageBableAiState extends State<MessageBableAi> {
  bool _showDot = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startBlinking();
  }

  @override
  void didUpdateWidget(MessageBableAi oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isStreaming != oldWidget.isStreaming) {
      if (widget.isStreaming) {
        _startBlinking();
      } else {
        _stopBlinking();
      }
    }
  }

  void _startBlinking() {
    if (!widget.isStreaming) return;

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showDot = !_showDot;
        });
      }
    });
  }

  void _stopBlinking() {
    _timer?.cancel();
    _timer = null;
    if (mounted) {
      setState(() {
        _showDot = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width * 0.17,
                    ),
                    padding: EdgeInsets.only(top: 16, right: 16, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                        color: AppColors.black1,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        )
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            widget.message,
                            style: TextStyle(
                                color: AppColors.white2,
                                fontSize: 16
                            ),
                          ),
                        ),
                        // 🔥 SIMPLE: Blinking dot using Timer
                        if (widget.isStreaming && _showDot) ...[
                          SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.white2,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -50,
                    left: 0,
                    child: ClipPath(
                      clipper: TriangleClipperAi(),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: AppColors.black1,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -52,
                    left: -15,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(0),
                      child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.url,
                            fit: BoxFit.fill,
                          )
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: -23,
                      right: widget.isStreaming ? 20 : 5,
                      child: Text(
                        "${widget.time.hour}:${widget.time.minute < 10 ? "0${widget.time.minute}" : widget.time.minute}",
                        style: TextStyle(
                            color: Color.fromRGBO(136, 136, 136, 1),
                            fontSize: 12
                        ),
                      )
                  )
                ]
            ),
          )
        ]
    );
  }
}