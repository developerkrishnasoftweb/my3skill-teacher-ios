import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/chats_provider.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/MyBehavior.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/mixins/after_build.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_m.dart';
import 'package:my3skill_teacher_ios/chat/preview_page.dart';
import 'package:my3skill_teacher_ios/chat/video_player_screen.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final studentId;
  final studentName;

  const ChatScreen({Key key, @required this.studentId, @required this.studentName}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with AfterLayoutMixin<ChatScreen> {
  TextEditingController _msgController = TextEditingController();
  FocusNode _msgFocusNode = FocusNode();

  ChatsProvider _provider;

  static ScrollController scrollController = ScrollController();

  int page = 0;

  String msgType = "t";
  String document = "";

  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    Provider.of<ChatsProvider>(context, listen: false).chatsList.clear();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
//    if (provider.chatsList != null && provider.chatsList.isEmpty) {
    _provider.lastId = await _provider.recentMessages({"student_id": widget.studentId});
    _provider.setLoading(false);
//    }
    showLog("chats size ==>> ${_provider.chatsList.length}");
//    _scrollController.addListener(() async {
//      if (_scrollController.position.pixels == 0.0) {
//        showLog("get more msg last ===>> ${_provider.lastId}");
//
//        if (_provider.lastId != "1") {
//          _refreshIndicatorKey.currentState?.show();
//          _provider.lastId = await _provider
//              .recentMessages({"teacher_id": widget.teacherId, "id": _provider.lastId});
//        } else {
//          showLog("no more data to load");
//        }
//      }
//    });
    scrollToBottom();
  }

  static void scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        Timer(Duration(milliseconds: 600), () => scrollToBottom());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<ChatsProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _provider.loading,
      child: BaseScaffold(
        title: widget.studentName,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: Column(
          children: [
            Expanded(child: _chatList()),
            _messageTextField(),
          ],
        ),
      ),
    );
  }

  Widget _chatList() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      child: ChangeNotifierProvider<ChatsProvider>.value(
        value: _provider,
        child: Consumer<ChatsProvider>(
          builder: (c, ChatsProvider m, cc) {
            showLog("something changed ===>> ${m.chatsList.length}");
            return ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.separated(
                controller: scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                itemCount: m.chatsList != null ? m.chatsList.length : 0,
                separatorBuilder: (c, i) {
                  return spacer(height: 5);
                },
                itemBuilder: (c, i) {
                  return _itemChat(m.chatsList[i]);
                },
              ),
            );
          },
        ),
      ),
      color: Palette.appThemeColor,
      onRefresh: () {
        return getMoreMessages();
      },
    );
  }

  Future<Null> getMoreMessages() async {
    if (_provider.lastId != "1") {
      _refreshIndicatorKey.currentState?.show();
      _provider.lastId = await _provider.recentMessages({"student_id": widget.studentId, "id": _provider.lastId});
    } else {
      showLog("no more data to load");
    }
  }

  Widget _messageTextField() {
    return StatefulBuilder(builder: (c, innerState) {
      return Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(width: 0.5, color: Colors.grey),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10),
                        child: TextField(
                          onChanged: (changedText) {
                            innerState(() {});
                          },
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.text,
                          style: Styles.customTextStyle(color: Colors.black, fontSize: 15.0),
                          autocorrect: true,
                          cursorColor: Palette.blackColor,
                          controller: _msgController,
                          textInputAction: TextInputAction.go,
                          focusNode: _msgFocusNode,
                          onSubmitted: (_) {},
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).enterMessage,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _msgController.text.isNotEmpty,
                      child: InkWell(
                        onTap: () {
                          msgType = "t";
                          document = null;
                          sendMessage();
                        },
                        child: Container(
                          height: 50.0,
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Palette.appThemeColor,
                                Palette.appThemeLightColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _msgController.text.isEmpty,
              child: InkWell(
                onTap: () {
                  showBottomSheet();
                },
                child: Container(
                  height: 50.0,
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Palette.appThemeColor,
                        Palette.appThemeLightColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  sendMessage() async {
    var message = _msgController.text;

    _msgController.clear();

    Map<String, dynamic> map = {
      "student": widget.studentId,
      "teacher": Constants.sharedPreferences.getString(Constants.USER_ID),
      "type": msgType,
      "sent_by": "t",
      "message": message
    };

    if (document != null && document.isNotEmpty && msgType != "t") {
      showLog("The selected file path : $document");

      var file = await MultipartFile.fromFile(
        document,
        filename: document.split("/").last.trim().toString(),
      );

      map.putIfAbsent("file", () => file);
    }

    var response = await _provider.sendMessage(map);
    if (response != null) {
      Chats chat = Chats(
        message: message,
        id: response.id.toString(),
        date: response.date,
        file: response.file,
        sentBy: response.sentBy,
        status: response.status,
        studentId: response.studentId,
        teacherId: response.teacherId,
        time: response.time,
        type: response.type,
      );

      _provider.chatsList.insert(_provider.chatsList.length, chat);
      scrollToBottom();
      showLog("sent");
      setState(() {});
    }
  }

  @override
  void dispose() async {
    _msgController.dispose();
    _msgFocusNode.dispose();
    _stopAllAudioRecorders();
    super.dispose();
  }

  void showBottomSheet() {
    hideKeyboard(context);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return _singleBottomSheetItem();
      },
    );
  }

  Widget _itemChat(Chats chat) {
    Widget messageWidget;
    switch (chat.type) {
      case "i":
        messageWidget = _getImageMessageType(chat);
        break;
      case "v":
        messageWidget = _getVideoMessageType(chat);
        break;
      case "a":
        messageWidget = _getAudioMessageType(chat);
        break;
      default:
        messageWidget = _getTextMessageType(chat);
        break;
    }

    return Align(
      alignment: chat.sentBy == "s" ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: messageWidget,
      ),
    );
  }

  void _kAudioStop() async {
    hideKeyboard(context);
    for (var i = 0; i < _provider.chatsList.length; ++i) {
      var o = _provider.chatsList[i];
      if (o.type == "a") {
        o.position = Duration(seconds: 0);
        if (o.audioPlayer != null) {
          await o.audioPlayer?.stop();
        }
      }
    }
    setState(() {});
  }

  Widget _getImageMessageType(Chats chat) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Hero(
        tag: chat.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: GestureDetector(
            onTap: () async {
              _kAudioStop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => PreviewPage(
                    url: chat.file,
                    isNetwork: true,
                    tag: chat.id,
                  ),
                ),
              );
            },
            child: _imageLayout(chat.file),
          ),
        ),
      ),
    );
  }

  Widget _getVideoMessageType(Chats chat) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: InkWell(
        onTap: () async {
          if (chat.file != null && chat.file.isNotEmpty) {
            _kAudioStop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => VideoPlayerScreen(
                  url: chat.file,
                  isNetwork: true,
                  isPreview: true,
                  isSend: false,
                ),
              ),
            );
          } else {
            showToast("Sorry file corrupted");
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getAudioMessageType(Chats chat) {
    var innerState;

    chat.playerState = PlayerState.STOPPED;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      chat.audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
        if (!mounted) {
          return;
        }
        innerState(() => chat.playerState = s);
      });
      chat.audioPlayer.onAudioPositionChanged.listen((Duration p) {
        if (!mounted) {
          return;
        }
        innerState(() => chat.position = p);
      });
      chat.audioPlayer.onDurationChanged.listen((Duration d) {
        if (!mounted) {
          return;
        }
        innerState(() => chat.duration = d);
      });
    });

    return StatefulBuilder(builder: (context, inner) {
      innerState = inner;
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Palette.appThemeColor,
              Palette.appThemeLightColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: InkWell(
                child: Icon(
                  chat.playerState == PlayerState.PAUSED || chat.playerState == PlayerState.STOPPED
                      ? Icons.play_arrow
                      : Icons.pause,
                  color: Colors.white,
                ),
                onTap: () async {
                  hideKeyboard(context);
                  if (chat.playerState == PlayerState.STOPPED) {
                    await _stopAllAudioRecorders();
                    await chat.audioPlayer.play(ApiUrls.IMAGE_URL + chat.file);
                  } else {
                    if (chat.playerState == PlayerState.PLAYING) {
                      await chat.audioPlayer.pause();
                    } else {
                      await chat.audioPlayer.resume();
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: Slider.adaptive(
                value: chat.position != null ? chat.position.inSeconds.toDouble() : 0.0,
                max: chat.duration != null ? chat.duration.inSeconds.toDouble() : 0.0,
                min: 0,
                activeColor: Colors.white,
                inactiveColor: Colors.grey[200].withOpacity(0.5),
                onChanged: (value) async {
                  await chat.audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _stopAllAudioRecorders() async {
    for (var i = 0; i < _provider.chatsList.length; ++i) {
      var o = _provider.chatsList[i];
      if (o.type == "a") {
        o.position = Duration(seconds: 0);
        if (o.audioPlayer != null) await o.audioPlayer?.release();
      }
    }
  }

  Widget _getTextMessageType(Chats chat) {
    BoxDecoration tDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Palette.appThemeColor,
          Palette.appThemeLightColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(5),
    );

    BoxDecoration sDecoration = BoxDecoration(
      color: Palette.appThemeLightColor.withOpacity(0.2),
      borderRadius: BorderRadius.circular(5),
    );

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: chat.sentBy == "t" ? tDecoration : sDecoration,
      child: Wrap(
        children: [
          Text(
            chat.message,
            style: Styles.customTextStyle(
              fontSize: 14,
              color: chat.sentBy == "t" ? Colors.white : Palette.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageLayout(String imageUrl) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      imageUrl: imageUrl != null && imageUrl.isNotEmpty
          ? ApiUrls.IMAGE_URL + imageUrl
          : "https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg",
      fit: BoxFit.cover,
      placeholder: (context, url) => _placeHolder(),
      errorWidget: (context, url, error) => _placeHolder(),
    );
  }

  Widget _placeHolder() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagesLink.PLACEHOLDER),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _singleBottomSheetItem() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color(0xFFF2F4FA),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Select',
            style: Styles.customTextStyle(
              fontWeight: FontWeight.w500,
              color: Palette.blackColor,
              fontSize: 21,
            ),
          ),
          const SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);

                  File pickedFile = File(image.path);

                  if (pickedFile != null) {
//                    var response =
//                        await Navigator.of(context).pushNamed(Routes.PREVIEW_PAGE, arguments: {
//                      AppRouteArgKeys.TYPE: 0,
//                      AppRouteArgKeys.SELECTED_FILE: pickedFile,
//                    });

                    var response = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => PreviewPage(
                          url: pickedFile.path,
                          isNetwork: false,
                        ),
                      ),
                    );

                    if (response != null) {
                      print("Picked image response is : ${pickedFile.path}");
                      document = pickedFile.path;
                      msgType = "i";
                      sendMessage();
                    }
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Palette.greyColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();
                  PickedFile image = await ImagePicker().getVideo(source: ImageSource.gallery);

                  if (image != null) {
                    File pickedFile = File(image.path);
//                    var response =
//                        await Navigator.of(context).pushNamed(Routes.PREVIEW_PAGE, arguments: {
//                      AppRouteArgKeys.TYPE: 1,
//                      AppRouteArgKeys.SELECTED_FILE: pickedFile,
//                    });

                    var response = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => VideoPlayerScreen(
                          url: pickedFile.path,
                          isNetwork: false,
                          isPreview: true,
                        ),
                      ),
                    );
                    if (response != null) {
                      print("Picked video response is : ${pickedFile.path}");
                      document = pickedFile.path;
                      msgType = "v";
                      sendMessage();
                    }
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Palette.greyColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.video_library,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              InkWell(
                onTap: () async {
                  Navigator.of(context).pop();

                  final pickedFile = await FilePicker.platform.pickFiles(
                    allowedExtensions: ['mp3', 'wav'],
                    type: FileType.custom,
                  );

                  if (pickedFile != null) {
                    document = pickedFile.paths.first;
                    msgType = "a";
                    sendMessage();
                  }
                },
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Palette.greyColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.audiotrack,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
