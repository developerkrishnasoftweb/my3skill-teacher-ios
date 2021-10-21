import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_m.dart';
import 'package:my3skill_teacher_ios/chat/chat_message_model.dart';

class ChatsProvider extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  List<Chats> chatsList = [];

  String lastId = "";

  Future<ChatResponseModel> sendMessage(Map map) async {
    if (await isNetworkConnected()) {
      var response = await ApiData.sendMessage(map);
      return response;
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  Future<String> recentMessages(Map<String, dynamic> map) async {
    if (await isNetworkConnected()) {
      if (chatsList.isEmpty) {
        setLoading(true);
      }
      print("The map is : $map");
      var response = await ApiData.recentMessage(map["student_id"], map["id"]);
      if (response != null && response.status == "true") {
        if (chatsList.isEmpty || map["id"] == null) {
          chatsList.clear();
          lastId = response.chats.last.id;
          chatsList.addAll(response.chats.reversed);
          setLoading(false);
        } else {
          chatsList.insertAll(0, response.chats.reversed);
        }
        notifyListeners();
        return response.chats.isNotEmpty ? response.chats.last.id : lastId;
      } else {
        showToast(response.message ?? Constants.SOMETHING_WENT_WRONG);
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  Future<void> getAllMessage(String teacherId, String messageId) async {
    if (await isNetworkConnected()) {
      setLoading(true);
      var response = await ApiData.getAllMessages(teacherId, messageId);

      setLoading(false);
      if (response != null && response.status == "true") {
        chatsList.addAll(response.chats);
        notifyListeners();
      } else {
        showToast(response.message ?? Constants.SOMETHING_WENT_WRONG);
      }
    } else {
      showToast(Constants.NO_INTERNET);
    }
    return null;
  }

  addMessage(Chats chats) {
    chatsList.add(chats);
    notifyListeners();
  }

  setLoading(value) {
    _loading = value;
    notifyListeners();
  }
}
