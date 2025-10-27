import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Constants/app_colors.dart';
import '../../../../Core/Providers/locale_provider.dart';
import 'package:chat_with_charachter/generated/l10n.dart';

import '../../../../Core/Services/preferences_service.dart';

class UserPreferences extends ConsumerStatefulWidget {
  const UserPreferences({super.key});

  @override
  ConsumerState<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends ConsumerState<UserPreferences> {
  // Remove the nullable types since we'll use the provider values directly
  String selectedLanguage = 'English';
  String selectedAudioLanguage = 'English (UK)';
  String selectedTheme = 'Dark';

  final PreferencesService _prefsService = PreferencesService();

  final languages = ['English', 'French', 'العربية'];
  final audioLanguages = ['English (UK)', 'English (US)', 'French (FR)', 'العربية'];
  final themes = ['Dark', 'Light'];

  @override
  void initState() {
    super.initState();
    _loadCurrentPreferences();
  }

  void _loadCurrentPreferences() {
    // Get current values from providers instead of SharedPreferences
    final currentLocale = ref.read(localeProvider);
    final currentTheme = ref.read(isDarkModeProvider);

    setState(() {
      // Set language based on current locale
      switch (currentLocale.languageCode) {
        case 'en':
          selectedLanguage = 'English';
          break;
        case 'fr':
          selectedLanguage = 'French';
          break;
        case 'ar':
          selectedLanguage = 'العربية';
          break;
        default:
          selectedLanguage = 'English';
      }

      // Set theme based on current theme
      selectedTheme = currentTheme ? 'Dark' : 'Light';

      // Audio language defaults
      selectedAudioLanguage = 'English (UK)';
    });
  }

  Widget _prefDropdown({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    bool isOpen = false;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Container(
          width: double.infinity,
          height: 0.09.sh,
          margin: EdgeInsets.only(bottom: 60.r),
          padding: EdgeInsets.symmetric(horizontal: 60.r),
          decoration: BoxDecoration(
            color: AppColors.black1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: AppColors.white2, fontSize: 48.sp),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: AppColors.black1,
                  value: value,
                  icon: AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.arrow_forward_ios,
                        color: AppColors.white2, size: 50.sp),
                  ),
                  style: TextStyle(color: AppColors.white2, fontSize: 48.sp),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    setInnerState(() => isOpen = !isOpen);
                  },
                  onChanged: (val) {
                    setInnerState(() => isOpen = false);
                    onChanged(val);
                  },
                  items: options.map((option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: TextStyle(
                            color: AppColors.white2, fontSize: 46.sp),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _prefTile({
    required String title,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 0.09.sh,
        margin: EdgeInsets.only(bottom: 60.r),
        padding: EdgeInsets.symmetric(horizontal: 60.r, vertical: 20.r),
        decoration: BoxDecoration(
          color: AppColors.black1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: AppColors.white2, fontSize: 50.sp),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios,
                  size: 50.sp, color: AppColors.white2),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.r),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.02.sh),
                Row(
                  children: [
                    BackButton(color: AppColors.white2),
                    SizedBox(width: 0.02.sw),
                    Text(
                      S.of(context).userPreferences,
                      style: TextStyle(
                        color: AppColors.white2,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.05.sh),
                _prefDropdown(
                  title: S.of(context).language,
                  value: selectedLanguage,
                  options: languages,
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => selectedLanguage = val);

                      String languageCode = 'en';
                      switch (val) {
                        case 'English':
                          languageCode = 'en';
                          break;
                        case 'French':
                          languageCode = 'fr';
                          break;
                        case 'العربية':
                          languageCode = 'ar';
                          break;
                      }

                      // Save to shared preferences
                      await _prefsService.saveLanguage(languageCode);

                      // Update app locale - this will trigger a rebuild of the entire app
                      ref.read(localeProvider.notifier).changeLocale(Locale(languageCode));
                    }
                  },
                ),
                _prefDropdown(
                  title: S.of(context).audioLanguage,
                  value: selectedAudioLanguage,
                  options: audioLanguages,
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => selectedAudioLanguage = val);
                      // You can add audio language saving here if needed
                    }
                  },
                ),
                _prefDropdown(
                  title: S.of(context).themeDisplay,
                  value: selectedTheme,
                  options: themes,
                  onChanged: (val) async {
                    if (val != null) {
                      setState(() => selectedTheme = val);

                      bool isDarkMode = val == 'Dark';

                      // Save to shared preferences
                      await _prefsService.saveTheme(isDarkMode);

                      // Update app theme - this will trigger a rebuild of the entire app
                      ref.read(isDarkModeProvider.notifier).state = isDarkMode;
                    }
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 80.r),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1, color: AppColors.black1),
                    ),
                  ),
                ),
                _prefTile(title: S.of(context).accountPrivacy, onTap: () {}),
                _prefTile(title: S.of(context).deactivateAccount, showArrow: false),
                _prefTile(title: S.of(context).deleteAccount, showArrow: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}