import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/login/login_page.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SplashScreenVideo extends StatefulWidget {
  @override
  _SplashScreenVideoState createState() => _SplashScreenVideoState();
}

class _SplashScreenVideoState extends State<SplashScreenVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //
    //   });

    _controller = VideoPlayerController.asset('assets/videos/splash_video.mp4');
    _controller.initialize().then((value) {
      setState(() {

      });
    }).catchError((onError){
      if (sharedPref.getKeys().isEmpty ||
          sharedPref.getBool(Constants.USER_LOGGED_IN) == null ||
          !sharedPref.getBool(Constants.USER_LOGGED_IN)) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        Navigator.of(context).pushReplacementNamed(Routes.HOME_SCREEN);
      }
    });

    _controller.setVolume(0);
    _controller.play();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (sharedPref.getKeys().isEmpty ||
          sharedPref.getBool(Constants.USER_LOGGED_IN) == null ||
          !sharedPref.getBool(Constants.USER_LOGGED_IN)) {
        showLog("Do nothing here!");
      } else {
        showLog("Call apis here!");
        Provider.of<AuthProvider>(context, listen: false).getUserProfile();
      }
    });

    showLog("student id ====>> ${sharedPref.getString(Constants.USER_ID)}");

    _controller.addListener(() {

      if (_controller.value.hasError) {
        print(_controller.value.errorDescription);
      }

      showLog("_controller.value.position ====> ${_controller.value.position}");
      if (_controller.value.position == _controller.value.duration) {
        if (sharedPref.getKeys().isEmpty ||
            sharedPref.getBool(Constants.USER_LOGGED_IN) == null ||
            !sharedPref.getBool(Constants.USER_LOGGED_IN)) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
        } else {
          Navigator.of(context).pushReplacementNamed(Routes.HOME_SCREEN);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
