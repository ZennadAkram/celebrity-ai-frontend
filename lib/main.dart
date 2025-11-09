import 'package:chat_with_charachter/Core/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'Core/Network/secure_storage.dart';
import 'Core/Providers/locale_provider.dart';
import 'Core/Services/camera_service.dart';
import 'Core/Services/preferences_service.dart';
import 'Features/Auth/presentation/views/Sign_In.dart';
import 'Features/Chats/presentation/views/speech_page.dart';
import 'Features/profile/data/models/user_hive_model.dart';
import 'Shared/Global_Widgets/Main_App.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:permission_handler/permission_handler.dart';

import 'generated/l10n.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Hive.initFlutter();

  Hive.registerAdapter(UserHiveModelAdapter());
  await Hive.openBox<UserHiveModel>('userBox');
  await Permission.camera.request();
  await CameraService.initCameras();

  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      final prefsService = PreferencesService();

      // Load saved preferences
      final savedTheme = await prefsService.getTheme();
      final savedLanguageCode = await prefsService.getLanguage();

      // Update providers
      ref.read(isDarkModeProvider.notifier).state = savedTheme;
      ref.read(localeProvider.notifier).changeLocale(Locale(savedLanguageCode));

      // Check login tokens
      final tokensEmpty = await TokenStorage.isTokensEmpty();
      if (!tokensEmpty) {
        _isLoggedIn = true; // user has tokens
      } else {
        _isLoggedIn = false; // user needs login
      }

    } catch (e) {
      print('Error initializing app: $e');
      ref.read(isDarkModeProvider.notifier).state = true;
      ref.read(localeProvider.notifier).changeLocale(const Locale('en'));
      _isLoggedIn = false;
    } finally {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  bool _isLoggedIn = false;


  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return MaterialApp(

        home: Scaffold(
          backgroundColor: Colors.black, // Use a neutral color
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand1),
                ),
                SizedBox(height: 20),
                Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    AppColors.setRef(ref);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final locale = ref.watch(localeProvider);

    final theme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.lightGreenAccent.withOpacity(0.5),
        cursorColor: AppColors.black1,
        selectionHandleColor: AppColors.brand1,
      ),
    );

    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.lightGreenAccent.withOpacity(0.5),
        cursorColor: AppColors.white2,
        selectionHandleColor: AppColors.brand1,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(1220, 2712),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnimatedTheme(
          data: isDarkMode ? darkTheme : theme,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            locale: locale,
            supportedLocales: S.delegate.supportedLocales,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: theme,
            darkTheme: darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              switchOutCurve: Curves.easeOut,
              child: Container(
                key: ValueKey<bool>(isDarkMode),
                color: Theme.of(context).scaffoldBackgroundColor,
                child:  _isLoggedIn ? MainApp() : SignIn()
              ),
            ),
          ),
        );
      },
    );
  }
}