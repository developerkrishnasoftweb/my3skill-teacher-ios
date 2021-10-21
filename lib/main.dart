import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my3skill_teacher_ios/add_course/add_course_image_screen.dart';
import 'package:my3skill_teacher_ios/add_course/add_course_screen.dart';
import 'package:my3skill_teacher_ios/add_course/main_course_page.dart';
import 'package:my3skill_teacher_ios/base/chats_provider.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/chat/chat_list_page.dart';
import 'package:my3skill_teacher_ios/chat/chat_screen.dart';
import 'package:my3skill_teacher_ios/course_list/course_list_page.dart';
import 'package:my3skill_teacher_ios/forgot_password/forgot_password.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/login/login_page.dart';
import 'package:my3skill_teacher_ios/profile/update_profile_page.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:my3skill_teacher_ios/providers/wallet_provider.dart';
import 'package:my3skill_teacher_ios/questions/questions_list.dart';
import 'package:my3skill_teacher_ios/questions/reply_questions_page.dart';
import 'package:my3skill_teacher_ios/resources/add_files_page.dart';
import 'package:my3skill_teacher_ios/resources/resources_list_page.dart';
import 'package:my3skill_teacher_ios/sections/view/sections_view.dart';
import 'package:my3skill_teacher_ios/services/push_notification_service.dart';
import 'package:my3skill_teacher_ios/signup/sign_up_page.dart';
import 'package:my3skill_teacher_ios/splashscreen/splash_screen.dart';
import 'package:my3skill_teacher_ios/students/students_screen.dart';
import 'package:my3skill_teacher_ios/subtitles/subtitle_list_page.dart';
import 'package:my3skill_teacher_ios/support/support_screen.dart';
import 'package:my3skill_teacher_ios/videos/add_video_page.dart';
import 'package:my3skill_teacher_ios/videos/video_list_page.dart';
import 'package:my3skill_teacher_ios/wallet/wallet_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base/commonwidgets/MyBehavior.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPref = await SharedPreferences.getInstance();

  Constants.loadUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider(null)),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => ChatsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale lastLocal = Locale('en');
  String initialData = 'en';
  StreamController<String> upwardsCom = StreamController();

  @override
  void initState() {
    super.initState();
    Constants.setSharedPrefs().then((sharedPrefs) {
      setState(() {
        initialData = sharedPrefs.getString(Constants.LANGUAGE_CODE) ?? 'en';
        sharedPrefs.setString(Constants.LANGUAGE_CODE, initialData);
        upwardsCom.add(initialData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _setTypes();
    // print("The initial data is : $initialData");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await PushNotificationService().initializePushNotification(context);
    });
    return StreamBuilder(
      initialData: initialData,
      stream: upwardsCom.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print("We have snapshot : ${snapshot.data}");
          lastLocal = Locale(snapshot.data);
        }
        return MaterialApp(
          title: Constants.APP_NAME,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: child,
            );
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(),
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizationsDelegate.supportedLocaleStrings
              .map((localeString) => Locale(localeString))
              .toList(),
          locale: lastLocal,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            Routes.SIGN_IN: (BuildContext context) => LoginPage(),
            Routes.FORGET_PASSWORD: (BuildContext context) =>
                ForgotPasswordScreen(),
          },
          onGenerateRoute: (RouteSettings settings) {
            Widget screen;
            var args = settings.arguments;
            String name = '';
            switch (settings.name) {
              case Routes.SIGN_UP:
                name = Routes.SIGN_UP;
                screen = _getSignUpPage(arguments: args);
                break;
              case Routes.HOME_SCREEN:
                name = Routes.HOME_SCREEN;
                screen = HomeScreenPage(
                  upwardsCom: upwardsCom,
                );
                break;
              case Routes.ADD_COURSE:
                name = Routes.ADD_COURSE;
                screen = _getAddCoursePage(dataMap: args);
                break;
              case Routes.MAIN_COURSE:
                name = Routes.MAIN_COURSE;
                screen = MainCoursePage();
                break;
              case Routes.WALLET:
                name = Routes.WALLET;
                screen = WalletScreen();
                break;
              case Routes.ADD_COURSE_IMAGE:
                name = Routes.ADD_COURSE_IMAGE;
                screen = _getAddCourseImagePage(dataMap: args);
                break;
              case Routes.VIDEOS_PAGE:
                name = Routes.VIDEOS_PAGE;
                screen = _getVideoListPage(dataMap: args);
                break;
              case Routes.SECTIONS_PAGE:
                name = Routes.SECTIONS_PAGE;
                screen = _getCourseSectionsPage(dataMap: args);
                break;
              case Routes.RESOURCES_PAGE:
                name = Routes.RESOURCES_PAGE;
                screen = _getResourcesListPage(dataMap: args);
                break;
              case Routes.SUBTITLES_PAGE:
                name = Routes.SUBTITLES_PAGE;
                screen = _getSubtitlesListPage(dataMap: args);
                break;
              case Routes.QUESTIONS_PAGE:
                name = Routes.QUESTIONS_PAGE;
                screen = _getQuestionsListPage(dataMap: args);
                break;
              case Routes.QUESTIONS_REPLY_PAGE:
                name = Routes.QUESTIONS_REPLY_PAGE;
                screen = _getReplyPage(dataMap: args);
                break;
              case Routes.ADD_RESOURCES_PAGE:
                name = Routes.ADD_RESOURCES_PAGE;
                screen = _getAddResourcesPage(dataMap: args);
                break;
              case Routes.ADD_SUBTITLES_PAGE:
                name = Routes.ADD_SUBTITLES_PAGE;
                screen = _getAddResourcesPage(dataMap: args);
                break;
              case Routes.ADD_VIDEO_PAGE:
                name = Routes.ADD_VIDEO_PAGE;
                screen = _getAddVideoPage(dataMap: args);
                break;
              case Routes.UPDATE_PROFILE_PAGE:
                name = Routes.UPDATE_PROFILE_PAGE;
                screen = UpdateProfilePage();
                break;
              case Routes.CHAT_LIST:
                name = Routes.CHAT_LIST;
                screen = ChatListPage();
                break;
              case Routes.STUDENTS:
                name = Routes.STUDENTS;
                screen = MyStudentsScreen();
                break;
              case Routes.SUPPORT:
                name = Routes.SUPPORT;
                screen = SupportScreen();
                break;
              case Routes.CHAT_SCREEN:
                name = Routes.CHAT_SCREEN;
                screen = _getChatPage(dataMap: args);
                break;
            }

//            if (screen != null && name != '') {
//              return NoAnimationMaterialPageRoute(
//                builder: (context) => screen,
//                settings: RouteSettings(
//                  name: name,
//                ),
//              );
//            }
            if (screen != null && name != '') {
              return MaterialPageRoute(
                builder: (_) => screen,
                settings: RouteSettings(
                  name: name,
                ),
              );
            }
            return null;
          },
          initialRoute: Routes.LAUNCHER,
          home: SplashScreenVideo(),
        );
      },
    );
  }

  Widget _getSignUpPage({Map arguments}) {
    return SignUpPage(
      user: arguments[AppRouteArgKeys.USER],
      type: arguments[AppRouteArgKeys.SOCIAL_TYPE],
    );
  }

  Widget _getAddCourseImagePage({Map<String, dynamic> dataMap}) {
    return AddCourseImage(
        courseModel: dataMap[AppRouteArgKeys.COURSE_MODEL],
        courseData: dataMap[AppRouteArgKeys.COURSE_DATA_MODEL]);
  }

  Widget _getVideoListPage({Map<String, dynamic> dataMap}) {
    return VideoListPage(sections: dataMap[AppRouteArgKeys.SECTION]);
  }

  Widget _getCourseSectionsPage({Map<String, dynamic> dataMap}) {
    return SectionList(courseId: dataMap[AppRouteArgKeys.COURSE_ID]);
  }

  Widget _getResourcesListPage({Map<String, dynamic> dataMap}) {
    return ResourcesListPage(videoId: dataMap[AppRouteArgKeys.VIDEO_ID]);
  }

  Widget _getSubtitlesListPage({Map<String, dynamic> dataMap}) {
    return SubtitlesListPage(videoId: dataMap[AppRouteArgKeys.VIDEO_ID]);
  }

  Widget _getQuestionsListPage({Map<String, dynamic> dataMap}) {
    return QuestionsListPage(videoId: dataMap[AppRouteArgKeys.VIDEO_ID]);
  }

  Widget _getReplyPage({Map<String, dynamic> dataMap}) {
    return ReplyQuestions(
      videoId: dataMap[AppRouteArgKeys.VIDEO_ID],
      question: dataMap[AppRouteArgKeys.QUESTION],
      questionId: dataMap[AppRouteArgKeys.QUESTION_ID],
    );
  }

  Widget _getAddResourcesPage({Map<String, dynamic> dataMap}) {
    return AddFilesPage(
      videoId: dataMap[AppRouteArgKeys.VIDEO_ID],
      type: dataMap[AppRouteArgKeys.TYPE],
    );
  }

  Widget _getAddVideoPage({Map<String, dynamic> dataMap}) {
    return AddVideoPage(
        courseId: dataMap[AppRouteArgKeys.COURSE_ID],
        sectionId: dataMap[AppRouteArgKeys.SECTION_ID]);
  }

  Widget _getChatPage({Map<String, dynamic> dataMap}) {
    return ChatScreen(
      studentId: dataMap[AppRouteArgKeys.STUDENT_ID],
      studentName: dataMap[AppRouteArgKeys.STUDENT_NAME],
    );
  }

  Widget _getAddCoursePage({Map<String, dynamic> dataMap}) {
    if (dataMap != null && dataMap[AppRouteArgKeys.COURSE_DATA_MODEL] != null) {
      return AddCoursePage(
        courseData: dataMap[AppRouteArgKeys.COURSE_DATA_MODEL],
      );
    } else return AddCoursePage();
  }

  void _setTypes() {
    if (Platform.isAndroid) {
      Constants.devicePlatform = 'Android';
    } else if (Platform.isIOS) {
      Constants.devicePlatform = 'iOS';
    }
  }
}

class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
