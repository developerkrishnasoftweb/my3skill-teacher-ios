import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/MyBehavior.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/chat/chat_list_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool isLoading = false;
  List<StudentModel> chats = List();

  @override
  void initState() {
    super.initState();
    _getChatsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
        inAsyncCall: isLoading,
        child: BaseScaffold(
            title: AppLocalizations.of(context).chats,
            isDrawerVisible: false,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.0),
                onPressed: () => Navigator.of(context).pop()),
            child: _chatListLayout()));
  }

  Widget _chatListLayout() {
    return Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(children: <Widget>[
          Expanded(
              child: chats != null && chats.length > 0
                  ? ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: ListView.builder(
                          itemCount: chats.length, itemBuilder: (context, index) => _itemData(chats[index])))
                  : Center(
                      child: Text(AppLocalizations.of(context).noChats,
                          style: TextStyle(color: Palette.appThemeColor, fontSize: 18.0))))
        ]));
  }

  Widget _itemData(StudentModel chatData) {
    return InkWell(
        onTap: () => Navigator.of(context).pushNamed(Routes.CHAT_SCREEN,
            arguments: {AppRouteArgKeys.STUDENT_ID: chatData.studentId, AppRouteArgKeys.STUDENT_NAME: chatData.name}),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Text(chatData.name ?? '',
                  style: Styles.customTextStyle(
                      fontWeight: FontWeight.normal, fontSize: 21.0, color: Palette.blackColor))),
          Divider(height: 1, thickness: 1, indent: 15, endIndent: 15)
        ]));
  }

  void _getChatsData() async {
    _startLoading();
//    var response = await ApiData.getChatList('1');

    var response = await ApiData.getChatList(Constants.sharedPreferences.getString(Constants.USER_ID));
    chats.clear();
    if (response != null && response.status == 'true' && response.student != null) {
      chats.addAll(response.student);
      _stopLoading();
    } else {
      _stopLoading();
      showToast('Something went wrong in fetching subtitles list. Please try again later.');
    }
  }

  void _startLoading() {
    setState(() => isLoading = true);
  }

  void _stopLoading() {
    setState(() => isLoading = false);
  }
}
