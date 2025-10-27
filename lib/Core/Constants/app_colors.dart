import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Dark mode provider
final isDarkModeProvider = StateProvider<bool>((ref) =>true);

class AppColors {
  static late WidgetRef _ref;

  // Set this once at app startup in main()
  static void setRef(WidgetRef ref) => _ref = ref;

  // Internal helper to check dark mode
  static bool get _isDark => _ref.read(isDarkModeProvider);

  // Brand Colors (normal constants)
  static const Color brand1 = Color(0xFF475BFF);
  static const Color brand2 = Color(0xFF2639E6);
  static const Color brand3 = Color(0xFF919BFF);
  static const Color brand4 = Color(0xFFBDC3F9);
  static const Color brand5 = Color(0xFFD7D8FB);
  static const Color brand6 = Color(0xFFE7E9FD);
  static const Color brand7 = Color(0xFFF1F3FE);
  static const Color brand8 = Color(0xFFF7F7FE);
  static const Color brand9 = Color(0xFFFAFAFE);

  // Secondary Colors (normal constants)
  static const Color secondary1 = Color(0xFFF58E2E);
  static const Color secondary2 = Color(0xFFF78012);
  static const Color secondary3 = Color(0xFFF9BB82);
  static const Color secondary4 = Color(0xFFFBD6B4);
  static const Color secondary5 = Color(0xFFFDE602);
  static const Color secondary6 = Color(0xFFFFE0E4);
  static const Color secondary7 = Color(0xFFFEF6EF);
  static const Color secondary8 = Color(0xFFFFFAF5);
  static const Color secondary9 = Color(0xFFFEEFC9);

  // Black & White (white2 and black1 are dynamic)
  static Color get black1 => !_isDark ? const Color(0xFFF9F9F9) : const Color(0xFF161616);
  static const Color black2 = Color(0xFF202020);
  static const Color black3 = Color(0xFF1E1E1E);

  static  Color grey0 = Color(0x87737373);
  static const Color grey1 = Color(0xFF737373);

  static  Color grey2 = Color(0xFFABABAB);
  static  Color grey3 = Color(0xFFCDCDCD);
  static Color grey4 = Color(0xFFE1E1E1);
  static  Color grey5 = Color(0xFFEDEDED);
  static  Color grey6 = Color(0xFFF0F0F0);

  static const Color white = Color(0xFFFFFFFF);
  static Color get white2 => !_isDark ? const Color(0xFF161616) : const Color(0xFFF9F9F9);

  // Gradients
  static const LinearGradient gradientBlue = LinearGradient(
    colors: [brand1, brand2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientOrange = LinearGradient(
    colors: [secondary1, secondary2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientOrange1 = LinearGradient(
    colors: [secondary2, secondary1],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient gradientMixed = LinearGradient(
    colors: [secondary1, brand1],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
