import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Features/Celebrity/presentation/views/explore.dart';
import '../../Features/Chats/presentation/views/chat_sessions_page.dart';
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

          //  Explore()
            ChatSessionsPage()
          ],
        ),
      ),
    );
  }
}
