import 'package:chat_with_charachter/Features/Auth/presentation/views/Sign_In.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_2.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_3.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/library/library_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_1.dart';
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
            LibraryPage()

          ],
        ),
      ),
    );
  }
}
