import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final bool isNetwork;
  final bool isPreview;
  final bool isSend;

  const VideoPlayerScreen({Key key, this.url, this.isNetwork = true, this.isPreview = false, this.isSend=true})
      : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;

  bool isShow = false;

  var _value;
  var _totalDuration;

  Timer _progressTimer;
  Timer _secondProgressTimer;

  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  _initPlayer() async {
    showLog("video url ===>> ${ApiUrls.IMAGE_URL + widget.url}");

    if (widget.isNetwork) {
      _controller = VideoPlayerController.network(
        // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        ApiUrls.IMAGE_URL + widget.url,
      );
    } else {
      _controller = VideoPlayerController.file(
        // "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        File(widget.url),
      );
    }

    _controller.addListener(() {
      setState(() {
        _value = _controller?.value?.position;
      });
    });
    _controller.setLooping(false);

    try {
      await _controller.initialize();
    } catch (e) {}

    setState(() {
      _totalDuration = _controller?.value?.duration;
    });

    _controller.play();
  }

  Future<bool> _willPopCallback() async {
    _controller.pause();
    return true; // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: _controller.value.isInitialized
            ? Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: isShow ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 200),
                      child: SafeArea(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.black12,
                          child: Visibility(
                            visible: isShow,
                            child: Container(
                              color: Colors.black12.withOpacity(0.5),
                              child: Column(
                                children: <Widget>[
                                  appBars(),
                                  Expanded(child: SizedBox()),
                                  _totalDuration >= _value ? progressIndicator() : SizedBox(),
                                  Visibility(
                                    visible: widget.isSend,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop('SUCCESS');
                                        },
                                        child: Container(
                                          height: 50.0,
                                          width: MediaQuery.of(context).size.width,
                                          margin: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            color: Palette.appThemeColor,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Send",
                                              style: Styles.customTextStyle(
                                                  color: Colors.white, fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: isShow ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Visibility(
                      visible: isShow,
                      child: Center(
                        child: controlWidgets(),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Loading...",
                        style: Styles.customTextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget controlWidgets() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                if (_controller.value.isPlaying) {
                  _controller.pause();
                } else {
                  _controller.play();
                  isShow = false;
                }
              });
            },
            icon: Center(
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 50.0,
              ),
            ),
          ),
          // SizedBox(width: 50),
          // IconButton(
          //   icon: Icon(
          //     Icons.play_arrow,
          //     color: Colors.white,
          //     size: 50,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }

  Widget _buildPosition() {
    final position = _value != null ? _value : Duration.zero;
    final duration = _totalDuration != null ? _totalDuration : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontFamily: "Cabin-Medium",
        ),
      ),
    );
  }

  String formatDuration(Duration position) {
    final ms = position.inMilliseconds;

    int seconds = ms ~/ 1000;
    final int hours = seconds ~/ 3600;
    seconds = seconds % 3600;
    var minutes = seconds ~/ 60;
    seconds = seconds % 60;

    final hoursString = hours >= 10 ? '$hours' : hours == 0 ? '00' : '0$hours';

    final minutesString = minutes >= 10 ? '$minutes' : minutes == 0 ? '00' : '0$minutes';

    final secondsString = seconds >= 10 ? '$seconds' : seconds == 0 ? '00' : '0$seconds';

    final formattedTime =
        '${hoursString == '00' ? '' : hoursString + ':'}$minutesString:$secondsString';

    return formattedTime;
  }

  Widget progressIndicator() {
    return Row(
      children: <Widget>[
        _buildPosition(),
        Expanded(
          child: Slider.adaptive(
            value: _controller.value.position.inSeconds.toDouble(),
            max: _controller.value.duration.inSeconds.toDouble(),
            min: 0,
            activeColor: Colors.white,
            inactiveColor: Colors.grey[200].withOpacity(0.5),
            onChanged: (value) {
              _controller.seekTo(Duration(seconds: value.toInt()));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: InkWell(
            child: Icon(
              Icons.fullscreen,
              color: Colors.white,
              size: 30,
            ),
            onTap: () {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
              } else {
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget appBars() {
    return Container(
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Visibility(
            visible: widget.isPreview,
            child: Expanded(
              child: Text(
                widget.url.split("/").last.trim().toString(),
                style: Styles.customTextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Visibility(
            visible: widget.isNetwork,
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {
                final RenderBox box = context.findRenderObject();
                Share.share("Share ${widget.url}",
                    subject: "Hey I found this course amazing.",
                    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _progressTimer?.cancel();
    _secondProgressTimer?.cancel();
    if (_controller != null) {
      _controller?.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
