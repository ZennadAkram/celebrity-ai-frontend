import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color brand1 = Color(0xFF475BFF);
  static const Color brand2 = Color(0xFF2639E6);
  static const Color brand3 = Color(0xFF919BFF);
  static const Color brand4 = Color(0xFFBDC3F9);
  static const Color brand5 = Color(0xFFD7D8FB);
  static const Color brand6 = Color(0xFFE7E9FD);
  static const Color brand7 = Color(0xFFF1F3FE);
  static const Color brand8 = Color(0xFFF7F7FE);
  static const Color brand9 = Color(0xFFFAFAFE);

  // Secondary Colors
  static const Color secondary1 = Color(0xFFFF582E);
  static const Color secondary2 = Color(0xFFF78012); // Hex corrected below
  static const Color secondary3 = Color(0xFFF9BB82);
  static const Color secondary4 = Color(0xFFFBD6B4);
  static const Color secondary5 = Color(0xFFFDE602);
  static const Color secondary6 = Color(0xFFFFE0E4);
  static const Color secondary7 = Color(0xFFFEF6EF);
  static const Color secondary8 = Color(0xFFFFFAF5);
  static const Color secondary9 = Color(0xFFFEEFC9);


  // Black & White Colors
  static const Color black1 = Color(0xFF161616);
  static const Color black2 = Color(0xFF202020);

  static const Color black3=Color(0xFF1E1E1E);
  static const Color grey0 = Color(0x87737373);
  static const Color grey1 = Color(0xFF737373);
  static const Color grey2 = Color(0xFFABABAB);
  static const Color grey3 = Color(0xFFCDCDCD);
  static const Color grey4 = Color(0xFFE1E1E1);
  static const Color grey5 = Color(0xFFEDEDED);
  static const Color grey6 = Color(0xFFF0F0F0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color white2=Color(0xFFF9F9F9);

  // Gradients (example with LinearGradient)
  static const LinearGradient gradientBlue = LinearGradient(
    colors: [Color(0xFF475BFF), Color(0xFF2639E6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientOrange = LinearGradient(
    colors: [Color(0xFFFF582E), Color(0xFFFF78012)], // corrected hex below
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gradientMixed = LinearGradient(
    colors: [Color(0xFF475BFF), Color(0xFFFF582E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
