import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/Constants/app_colors.dart';
import '../../../../Core/Providers/locale_provider.dart';

class UserPreferences extends ConsumerStatefulWidget {
  const UserPreferences({super.key});

  @override
  ConsumerState<UserPreferences> createState() => _UserPreferencesState();
}

class _UserPreferencesState extends ConsumerState<UserPreferences> {
  String selectedLanguage = 'English';
  String selectedAudioLanguage = 'English (UK)';
  String selectedTheme = 'Dark';

  final languages = ['English', 'French', 'العربية'];
  final audioLanguages = ['English (UK)', 'English (US)', 'French (FR)', 'العربية'];
  final themes = ['Dark', 'Light', 'System'];

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
                    turns: isOpen ? 0.5 : 0, // rotates 180° down
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.arrow_forward_ios,
                        color: AppColors.white2, size: 50.sp),
                  ),
                  style: TextStyle(color: AppColors.white2, fontSize: 48.sp),
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    // Toggle arrow when dropdown opens
                    setInnerState(() => isOpen = !isOpen);
                  },
                  onChanged: (val) {
                    setInnerState(() => isOpen = false); // reset arrow when closed
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
      backgroundColor: Colors.black,
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
                    const BackButton(color: AppColors.white2),
                    SizedBox(width: 0.02.sw),
                    Text(
                      'User Preferences',
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
                  title: 'Language',
                  value: selectedLanguage,
                  options: languages,
                  onChanged: (val) {
                      setState(() => selectedLanguage = val!);
                    if (val == 'English') {
          ref.read(localeProvider.notifier).changeLocale(const Locale('en'));
          } else if (val == 'French') {
        ref.read(localeProvider.notifier).changeLocale(const Locale('fr'));
        } else if (val == 'العربية') {
      ref.read(localeProvider.notifier).changeLocale(const Locale('ar'));
      }},
                ),
                _prefDropdown(
                  title: 'Audio Language',
                  value: selectedAudioLanguage,
                  options: audioLanguages,
                  onChanged: (val) =>
                      setState(() => selectedAudioLanguage = val!),
                ),
                _prefDropdown(
                  title: 'Theme Display',
                  value: selectedTheme,
                  options: themes,
                  onChanged: (val) => setState(() => selectedTheme = val!),
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
                _prefTile(title: 'Account Privacy', onTap: () {}),
                _prefTile(title: 'Deactivate Account', showArrow: false),
                _prefTile(title: 'Delete Account', showArrow: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
