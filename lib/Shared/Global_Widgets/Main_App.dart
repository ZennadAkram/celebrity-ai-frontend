import 'package:chat_with_charachter/Features/Auth/presentation/views/Sign_In.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_1.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_2.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_3.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/library/library_page.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/explore.dart';
import 'package:chat_with_charachter/Features/Chats/presentation/views/chat_sessions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Features/profile/presentation/views/profile_page.dart';
import 'bottom_nav_bar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    Explore(),                  // 🧭 Explore
    const ChatSessionsPage(),   // 💬 Chat
    const CreateCelebrityPage1(), // ➕ Create
    const LibraryPage(),
    const ProfilePage()// 📚 Library
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: true,
      body: SafeArea(
        // 👇 Smooth animation between pages
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            // 👇 Combine fade + slide effect
            final slideAnimation = Tween<Offset>(
              begin: const Offset(0.05, 0), // slide from right slightly
              end: Offset.zero,
            ).animate(animation);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slideAnimation,
                child: child,
              ),
            );
          },
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
