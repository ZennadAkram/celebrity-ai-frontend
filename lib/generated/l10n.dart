// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `User Preferences`
  String get userPreferences {
    return Intl.message(
      'User Preferences',
      name: 'userPreferences',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Audio Language`
  String get audioLanguage {
    return Intl.message(
      'Audio Language',
      name: 'audioLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Theme Display`
  String get themeDisplay {
    return Intl.message(
      'Theme Display',
      name: 'themeDisplay',
      desc: '',
      args: [],
    );
  }

  /// `Account Privacy`
  String get accountPrivacy {
    return Intl.message(
      'Account Privacy',
      name: 'accountPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Deactivate Account`
  String get deactivateAccount {
    return Intl.message(
      'Deactivate Account',
      name: 'deactivateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `60% OFF`
  String get sixtyOff {
    return Intl.message('60% OFF', name: 'sixtyOff', desc: '', args: []);
  }

  /// `Get Character.AI Premium to enjoy all the benefits!`
  String get premiumTitle {
    return Intl.message(
      'Get Character.AI Premium to enjoy all the benefits!',
      name: 'premiumTitle',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe to Character.AI Premium and get unlimited access to all our models and voices!`
  String get premiumSubtitle {
    return Intl.message(
      'Subscribe to Character.AI Premium and get unlimited access to all our models and voices!',
      name: 'premiumSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Start Now`
  String get startNow {
    return Intl.message('Start Now', name: 'startNow', desc: '', args: []);
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `1 Month`
  String get month1 {
    return Intl.message('1 Month', name: 'month1', desc: '', args: []);
  }

  /// `3 Months`
  String get month3 {
    return Intl.message('3 Months', name: 'month3', desc: '', args: []);
  }

  /// `12 Months`
  String get month12 {
    return Intl.message('12 Months', name: 'month12', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Character.AI Premium`
  String get characterAIPremium {
    return Intl.message(
      'Character.AI Premium',
      name: 'characterAIPremium',
      desc: '',
      args: [],
    );
  }

  /// `Get Character.AI Premium to enjoy all the benefits!`
  String get getPremiumBenefit {
    return Intl.message(
      'Get Character.AI Premium to enjoy all the benefits!',
      name: 'getPremiumBenefit',
      desc: '',
      args: [],
    );
  }

  /// `About Character.AI`
  String get aboutCharacterAI {
    return Intl.message(
      'About Character.AI',
      name: 'aboutCharacterAI',
      desc: '',
      args: [],
    );
  }

  /// `Follow on Social Media`
  String get followOnSocialMedia {
    return Intl.message(
      'Follow on Social Media',
      name: 'followOnSocialMedia',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message('Feedback', name: 'feedback', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `or login with`
  String get or_login_with {
    return Intl.message(
      'or login with',
      name: 'or_login_with',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account? `
  String get dont_have_account {
    return Intl.message(
      'Don’t have an account? ',
      name: 'dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Register Now`
  String get register_now {
    return Intl.message(
      'Register Now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get log_in {
    return Intl.message('Log in', name: 'log_in', desc: '', args: []);
  }

  /// `to your account`
  String get to_your_account {
    return Intl.message(
      'to your account',
      name: 'to_your_account',
      desc: '',
      args: [],
    );
  }

  /// `your account`
  String get your_account {
    return Intl.message(
      'your account',
      name: 'your_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `By pressing “Register” you will accept`
  String get by_pressing_register_you_agree_to {
    return Intl.message(
      'By pressing “Register” you will accept',
      name: 'by_pressing_register_you_agree_to',
      desc: '',
      args: [],
    );
  }

  /// `UID`
  String get uid {
    return Intl.message('UID', name: 'uid', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message('Library', name: 'library', desc: '', args: []);
  }

  /// `Public`
  String get publicTab {
    return Intl.message('Public', name: 'publicTab', desc: '', args: []);
  }

  /// `Private`
  String get privateTab {
    return Intl.message('Private', name: 'privateTab', desc: '', args: []);
  }

  /// `Failed to load celebrities`
  String get failedToLoadCelebrities {
    return Intl.message(
      'Failed to load celebrities',
      name: 'failedToLoadCelebrities',
      desc: '',
      args: [],
    );
  }

  /// `Create Character`
  String get createCharacterTitle {
    return Intl.message(
      'Create Character',
      name: 'createCharacterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Character`
  String get createYourCharacterButton {
    return Intl.message(
      'Create Your Character',
      name: 'createYourCharacterButton',
      desc: '',
      args: [],
    );
  }

  /// `Character name`
  String get characterNameHint {
    return Intl.message(
      'Character name',
      name: 'characterNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Choose gender`
  String get chooseGenderHint {
    return Intl.message(
      'Choose gender',
      name: 'chooseGenderHint',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Character info`
  String get characterInfoLabel {
    return Intl.message(
      'Character info',
      name: 'characterInfoLabel',
      desc: '',
      args: [],
    );
  }

  /// `Describe your character information`
  String get characterDescriptionHint {
    return Intl.message(
      'Describe your character information',
      name: 'characterDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Greeting`
  String get greetingLabel {
    return Intl.message('Greeting', name: 'greetingLabel', desc: '', args: []);
  }

  /// `Type your greeting here`
  String get greetingHint {
    return Intl.message(
      'Type your greeting here',
      name: 'greetingHint',
      desc: '',
      args: [],
    );
  }

  /// `Visibility`
  String get visibilityLabel {
    return Intl.message(
      'Visibility',
      name: 'visibilityLabel',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get publicOption {
    return Intl.message('Public', name: 'publicOption', desc: '', args: []);
  }

  /// `Private`
  String get privateOption {
    return Intl.message('Private', name: 'privateOption', desc: '', args: []);
  }

  /// `Advanced (optional)`
  String get advancedOptional {
    return Intl.message(
      'Advanced (optional)',
      name: 'advancedOptional',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get nextButton {
    return Intl.message('Next', name: 'nextButton', desc: '', args: []);
  }

  /// `Appearance Description`
  String get appearanceDescriptionLabel {
    return Intl.message(
      'Appearance Description',
      name: 'appearanceDescriptionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Type your appearance description here`
  String get appearanceDescriptionHint {
    return Intl.message(
      'Type your appearance description here',
      name: 'appearanceDescriptionHint',
      desc: '',
      args: [],
    );
  }

  /// `Character Category`
  String get characterCategoryLabel {
    return Intl.message(
      'Character Category',
      name: 'characterCategoryLabel',
      desc: '',
      args: [],
    );
  }

  /// `No image selected.`
  String get noImageSelected {
    return Intl.message(
      'No image selected.',
      name: 'noImageSelected',
      desc: '',
      args: [],
    );
  }

  /// `Choose Avatar`
  String get chooseAvatar {
    return Intl.message(
      'Choose Avatar',
      name: 'chooseAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Choose Background`
  String get chooseBackground {
    return Intl.message(
      'Choose Background',
      name: 'chooseBackground',
      desc: '',
      args: [],
    );
  }

  /// `Create Celebrity`
  String get createCelebrity {
    return Intl.message(
      'Create Celebrity',
      name: 'createCelebrity',
      desc: '',
      args: [],
    );
  }

  /// `Character successfully created`
  String get characterCreatedTitle {
    return Intl.message(
      'Character successfully created',
      name: 'characterCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your character has been successfully created`
  String get characterCreatedSubtitle {
    return Intl.message(
      'Your character has been successfully created',
      name: 'characterCreatedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `View on Library`
  String get viewOnLibrary {
    return Intl.message(
      'View on Library',
      name: 'viewOnLibrary',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get exploreTitle {
    return Intl.message('Explore', name: 'exploreTitle', desc: '', args: []);
  }

  /// `Search`
  String get searchHint {
    return Intl.message('Search', name: 'searchHint', desc: '', args: []);
  }

  /// `All`
  String get allCategory {
    return Intl.message('All', name: 'allCategory', desc: '', args: []);
  }

  /// `Movies`
  String get moviesCategory {
    return Intl.message('Movies', name: 'moviesCategory', desc: '', args: []);
  }

  /// `Series`
  String get seriesCategory {
    return Intl.message('Series', name: 'seriesCategory', desc: '', args: []);
  }

  /// `Cartoons`
  String get cartoonsCategory {
    return Intl.message(
      'Cartoons',
      name: 'cartoonsCategory',
      desc: '',
      args: [],
    );
  }

  /// `Anime`
  String get animeCategory {
    return Intl.message('Anime', name: 'animeCategory', desc: '', args: []);
  }

  /// `Documentary`
  String get documentaryCategory {
    return Intl.message(
      'Documentary',
      name: 'documentaryCategory',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorLabel {
    return Intl.message('Error', name: 'errorLabel', desc: '', args: []);
  }

  /// `Create your character with us!`
  String get createYourCharacterWithUs {
    return Intl.message(
      'Create your character with us!',
      name: 'createYourCharacterWithUs',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chatsTitle {
    return Intl.message('Chats', name: 'chatsTitle', desc: '', args: []);
  }

  /// `Error loading chats`
  String get errorLoadingChats {
    return Intl.message(
      'Error loading chats',
      name: 'errorLoadingChats',
      desc: '',
      args: [],
    );
  }

  /// `Error loading messages`
  String get errorLoadingMessages {
    return Intl.message(
      'Error loading messages',
      name: 'errorLoadingMessages',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryButton {
    return Intl.message('Retry', name: 'retryButton', desc: '', args: []);
  }

  /// `Loading messages...`
  String get loadingMessages {
    return Intl.message(
      'Loading messages...',
      name: 'loadingMessages',
      desc: '',
      args: [],
    );
  }

  /// `No messages yet`
  String get noMessagesYet {
    return Intl.message(
      'No messages yet',
      name: 'noMessagesYet',
      desc: '',
      args: [],
    );
  }

  /// `Type a message...`
  String get typeMessageHint {
    return Intl.message(
      'Type a message...',
      name: 'typeMessageHint',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTitle {
    return Intl.message('Profile', name: 'profileTitle', desc: '', args: []);
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
