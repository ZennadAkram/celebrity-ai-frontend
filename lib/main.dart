import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_2.dart';
import 'package:chat_with_charachter/Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_4.dart';
import 'package:chat_with_charachter/Features/Onboarding/Onboarding-2.dart';
import 'package:chat_with_charachter/Features/Onboarding/Onboarding-3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Core/Providers/locale_provider.dart';
import 'Core/Services/camera_service.dart';
import 'Features/Auth/presentation/views/Sign_In.dart';
import 'Features/Auth/presentation/views/Sign_Up.dart';
import 'Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_3.dart';
import 'Features/Celebrity/presentation/views/create_celebrity_views/create_celebrity_page_5.dart';
import 'Features/Onboarding/Onboarding-1.dart';
import 'Shared/Global_Widgets/Main_App.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:permission_handler/permission_handler.dart';

import 'generated/l10n.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");


  await Permission.camera.request();


  await CameraService.initCameras();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(1220, 2712),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: locale,
          supportedLocales: S.delegate.supportedLocales,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: Colors.lightGreenAccent.withOpacity(0.5),
              cursorColor: Colors.white,
              selectionHandleColor: AppColors.brand1,
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: MainApp(),
        );
      },
    );
  }
}



