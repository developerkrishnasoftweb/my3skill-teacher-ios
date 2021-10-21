import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my3skill_teacher_ios/i18n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static bool isDirectionRTL(BuildContext context) {
    return Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get enterAssociateEmail =>
      Intl.message('', name: 'enterAssociateEmail', desc: '');

  String get login => Intl.message('', name: 'login', desc: '');

  String get emailAddress => Intl.message('', name: 'emailAddress', desc: '');

  String get password => Intl.message('', name: 'password', desc: '');

  String get forgotPassword =>
      Intl.message('', name: 'forgotPassword', desc: '');

  String get forgotPassword2 =>
      Intl.message('', name: 'forgotPassword2', desc: '');

  String get loginGoogle => Intl.message('', name: 'loginGoogle', desc: '');

  String get loginFacebook => Intl.message('', name: 'loginFacebook', desc: '');

  String get alreadyRegistered =>
      Intl.message('', name: 'alreadyRegistered', desc: '');

  String get register => Intl.message('', name: 'register', desc: '');

  String get privacyPolicy => Intl.message('', name: 'privacyPolicy', desc: '');

  String get and => Intl.message('', name: 'and', desc: '');

  String get tAndC => Intl.message('', name: 'tAndC', desc: '');

  String get fullName => Intl.message('', name: 'fullName', desc: '');

  String get phoneNumber => Intl.message('', name: 'phoneNumber', desc: '');

  String get emailMe => Intl.message('', name: 'emailMe', desc: '');

  String get signUpGoogle => Intl.message('', name: 'signUpGoogle', desc: '');

  String get signUpFacebook =>
      Intl.message('', name: 'signUpFacebook', desc: '');

  String get validEmail => Intl.message('', name: 'validEmail', desc: '');

  String get validFullname => Intl.message('', name: 'validFullname', desc: '');

  String get validPassword => Intl.message('', name: 'validPassword', desc: '');

  String get validPhone => Intl.message('', name: 'validPhone', desc: '');

  String get search => Intl.message('', name: 'search', desc: '');

  String get courseList => Intl.message('', name: 'courseList', desc: '');

  String get notification => Intl.message('', name: 'notification', desc: '');

  String get messages => Intl.message('', name: 'messages', desc: '');

  String get wallet => Intl.message('', name: 'wallet', desc: '');

  String get logout => Intl.message('', name: 'logout', desc: '');

  String get videoList => Intl.message('', name: 'videoList', desc: '');

  String get sections => Intl.message('', name: 'sections', desc: '');

  String get resource => Intl.message('', name: 'resource', desc: '');

  String get subtitle => Intl.message('', name: 'subtitle', desc: '');

  String get questions => Intl.message('', name: 'questions', desc: '');

  String get resourceList => Intl.message('', name: 'resourceList', desc: '');

  String get subtitleList => Intl.message('', name: 'subtitleList', desc: '');

  String get questionsList => Intl.message('', name: 'questionsList', desc: '');

  String get noCourses => Intl.message('', name: 'noCourses', desc: '');

  String get noVideos => Intl.message('', name: 'noVideos', desc: '');

  String get noResources => Intl.message('', name: 'noResources', desc: '');

  String get noSubtitles => Intl.message('', name: 'noSubtitles', desc: '');

  String get noQuestions => Intl.message('', name: 'noQuestions', desc: '');

  String get addAnswer => Intl.message('', name: 'addAnswer', desc: '');

  String get or => Intl.message('', name: 'or', desc: '');

  String get addVideo => Intl.message('', name: 'addVideo', desc: '');

  String get courseTitle => Intl.message('', name: 'courseTitle', desc: '');

  String get courseDescription =>
      Intl.message('', name: 'courseDescription', desc: '');

  String get coursePrice => Intl.message('', name: 'coursePrice', desc: '');

  String get courseImage => Intl.message('', name: 'courseImage', desc: '');

  String get uploadImage => Intl.message('', name: 'uploadImage', desc: '');
  String get uploadSubtitle => Intl.message('', name: 'uploadSubtitle', desc: '');

  String get promotionalVideo =>
      Intl.message('', name: 'promotionalVideo', desc: '');

  String get uploadVideo => Intl.message('', name: 'uploadVideo', desc: '');

  String get submit => Intl.message('', name: 'submit', desc: '');

  String get addResource => Intl.message('', name: 'addResource', desc: '');

  String get videoResource => Intl.message('', name: 'videoResource', desc: '');

  String get addSubtitles => Intl.message('', name: 'addSubtitles', desc: '');

  String get subtitlesSmall =>
      Intl.message('', name: 'subtitlesSmall', desc: '');

  String get videoSubtitles =>
      Intl.message('', name: 'videoSubtitles', desc: '');

  String get addCourse => Intl.message('', name: 'addCourse', desc: '');

  String get updateCourse => Intl.message('', name: 'updateCourse', desc: '');

  String get courseSubtitle =>
      Intl.message('', name: 'courseSubtitle', desc: '');

  String get basicInfo => Intl.message('', name: 'basicInfo', desc: '');

  String get selectLanguage =>
      Intl.message('', name: 'selectLanguage', desc: '');

  String get selectLevel => Intl.message('', name: 'selectLevel', desc: '');

  String get chooseCategory =>
      Intl.message('', name: 'chooseCategory', desc: '');

  String get chooseSubCategory =>
      Intl.message('', name: 'chooseSubCategory', desc: '');

  String get chooseTopic => Intl.message('', name: 'chooseTopic', desc: '');

  String get whatLearn => Intl.message('', name: 'whatLearn', desc: '');

  String get completionDays =>
      Intl.message('', name: 'completionDays', desc: '');

  String get next => Intl.message('', name: 'next', desc: '');

  String get courseTitleError =>
      Intl.message('', name: 'courseTitleError', desc: '');

  String get coursePositionError =>
      Intl.message('', name: 'coursePositionError', desc: '');

  String get courseSubTitleError =>
      Intl.message('', name: 'courseSubTitleError', desc: '');

  String get courseDescError =>
      Intl.message('', name: 'courseDescError', desc: '');

  String get whatLearnError =>
      Intl.message('', name: 'whatLearnError', desc: '');

  String get coursePriceError =>
      Intl.message('', name: 'coursePriceError', desc: '');

  String get courseDaysError =>
      Intl.message('', name: 'courseDaysError', desc: '');

  String get resourceTitleError =>
      Intl.message('', name: 'resourceTitleError', desc: '');

  String get subTitleError => Intl.message('', name: 'subTitleError', desc: '');

  String get questionListError =>
      Intl.message('', name: 'questionListError', desc: '');

  String get questionAnswer =>
      Intl.message('', name: 'questionAnswer', desc: '');

  String get question => Intl.message('', name: 'question', desc: '');

  String get answer => Intl.message('', name: 'answer', desc: '');

  String get validAnswer => Intl.message('', name: 'validAnswer', desc: '');

  String get updateProfile => Intl.message('', name: 'updateProfile', desc: '');

  String get teacherName => Intl.message('', name: 'teacherName', desc: '');

  String get tagLine => Intl.message('', name: 'tagLine', desc: '');

  String get description => Intl.message('', name: 'description', desc: '');

  String get tags => Intl.message('', name: 'tags', desc: '');

  String get twitterUrl => Intl.message('', name: 'twitterUrl', desc: '');

  String get facebookUrl => Intl.message('', name: 'facebookUrl', desc: '');

  String get linkedInUrl => Intl.message('', name: 'linkedInUrl', desc: '');

  String get youtubeUrl => Intl.message('', name: 'youtubeUrl', desc: '');

  String get update => Intl.message('', name: 'update', desc: '');

  String get chooseLanguage =>
      Intl.message('', name: 'chooseLanguage', desc: '');

  String get english => Intl.message('', name: 'english', desc: '');

  String get spanish => Intl.message('', name: 'spanish', desc: '');

  String get hindi => Intl.message('', name: 'hindi', desc: '');

  String get urdu => Intl.message('', name: 'urdu', desc: '');

  String get chinese => Intl.message('', name: 'chinese', desc: '');

  String get walletBalance => Intl.message('', name: 'walletBalance', desc: '');

  String get noTransaction => Intl.message('', name: 'noTransaction', desc: '');

  String get withdrawMoney => Intl.message('', name: 'withdrawMoney', desc: '');

  String get depositMoney => Intl.message('', name: 'depositMoney', desc: '');

  String get closingBalance =>
      Intl.message('', name: 'closingBalance', desc: '');

  String get chats => Intl.message('', name: 'chats', desc: '');

  String get noChats => Intl.message('', name: 'noChats', desc: '');

  String get enterMessage => Intl.message('', name: 'enter_message', desc: '');

  String get noCourse => Intl.message('', name: 'noCourse', desc: '');
  String get requirements => Intl.message('', name: 'requirements', desc: '');
  String get courseIncludes => Intl.message('', name: 'courseIncludes', desc: '');
  String get discountedPrice => Intl.message('', name: 'discountedPrice', desc: '');
}

class Language {
  String name;
  String code;

  Language(this.name, this.code);

  Locale getLocale() {
    return Locale(this.code);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

//  static List<String> supportedLocaleStrings = ['en','ar','fr','de','zh','nl','it','es','pt','da','sv','fi','no','ko','ja','ru','pl','tr','uk','hu', 'th','cs','el','he','id','ms','ro','sk','hr','ca','vi','hi','ur','bn','sr','af'];
  static List<String> supportedLocaleStrings = ['en', 'es', 'hi', 'ur', 'zh'];
  static List<Language> languages = [
    Language("English", "en"),
    Language("Español", "es"),
    Language("हिन्दी", "hi"),
    Language("اردو", "ur"),
    Language("汉语", "zh"),
  ];

  @override
  bool isSupported(Locale locale) {
    return supportedLocaleStrings.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
