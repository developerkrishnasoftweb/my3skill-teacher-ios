import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/chats_provider.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_m.dart';
import 'package:my3skill_teacher_ios/chat/chat_screen.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  initializePushNotification(BuildContext context) async {
    final _fcm = FirebaseMessaging.instance;
    if (Platform.isIOS) {
      _fcm.requestPermission();
    }

    var deviceToken = await _fcm.getToken();
    Constants.USER_TOKEN = deviceToken;
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     var msg = message['data'];
    //     showLog("onMessage data --->> $msg");
    //     receiveMessage(context, msg);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     var msg = message['data'];
    //     showLog("onLaunch data --->> $msg");
    //     receiveMessage(context, msg);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     var msg = message['data'];
    //     showLog("onResume data --->> $msg");
    //     receiveMessage(context, msg);
    //   },
    // );
  }

  void receiveMessage(context, msg) async {
    Chats chat = Chats(
      teacherId: msg['teacher_id'],
      studentId: msg['student_id'],
      date: msg['date'],
      time: msg['time'],
      type: msg['type'],
      message: msg['message'],
      sentBy: msg['sent_by'],
      file: msg['file'],
      status: msg['status'],
      id: msg['id'],
    );
    var provider = Provider.of<ChatsProvider>(context, listen: false);

    try {
      await provider.addMessage(chat);
      ChatScreenState.scrollToBottom();
    } catch (e) {
      showLog(e.toString());
    }
  }
}
