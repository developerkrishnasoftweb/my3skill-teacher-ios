import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/wave_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/payouts/payouts_screen.dart';
import 'package:my3skill_teacher_ios/wallet/wallet_screen.dart';

class BaseScaffold extends StatefulWidget {
  final Widget child;
  final Color bgColor;
  final String title;
  final int selectedIndex;
  final bool produceWaveTitle;
  final Widget singleActionIcon;
  final Widget leading;
  final bool isDrawerVisible;
  final StreamController<String> upwards;
  final bool showLanguage;
  final VoidCallback onPremium;

  const BaseScaffold({
    Key key,
    this.bgColor: Colors.white,
    @required this.title,
    @required this.child,
    this.selectedIndex: 0,
    this.produceWaveTitle: true,
    this.singleActionIcon,
    this.leading,
    this.isDrawerVisible: false,
    this.upwards,
    this.showLanguage: false,
    this.onPremium,
  }) : super(key: key);

  @override
  _BaseScaffoldState createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  int selectedIndex = -1;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<LanguageClass> lists = List();

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: widget.bgColor,
      key: _scaffoldKey,
      drawer: widget.isDrawerVisible ? _navDrawer() : null,
      body: Column(
        children: <Widget>[
          _waveTitle(),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _waveTitle() {
    return Visibility(
      visible: widget.produceWaveTitle,
      child: Container(
        height: screenHeight / 7.5,
        width: screenWidth,
        color: Colors.transparent,
        child: ClipPath(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Palette.appThemeColor,
                    Palette.appThemeLightColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: Styles.customTextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      widget.leading != null
                          ? SizedBox(
                              child: widget.leading,
                            )
                          : widget.isDrawerVisible
                              ? InkWell(
                                  onTap: () {
                                    _scaffoldKey.currentState.openDrawer();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      width: 45.0,
                                      child: Icon(
                                        Icons.format_list_bulleted,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: widget.showLanguage,
                            child: IconButton(
                                icon: Icon(
                                  Icons.language,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _showSuccessDialog();
                                }),
                          ),
                          SizedBox(
                            child: widget.singleActionIcon,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
          clipper: WaveGeneratorPath(
            amount: 10.0,
            depth: 10.0,
            orientation: OrientationWave.DOWN_REVERSE,
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              child: Container(
                  padding: const EdgeInsets.all(20.0),
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.4,
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Text(AppLocalizations.of(context).chooseLanguage,
                        style: Styles.customTextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12.0),
                    Expanded(
                        child: ListView.builder(
                            itemCount: AppLocalizationsDelegate.languages.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Constants.sharedPreferences.setString(
                                        Constants.LANGUAGE_CODE, AppLocalizationsDelegate.languages[index].code);
                                    widget.upwards.add(AppLocalizationsDelegate.languages[index].code);
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Text(AppLocalizationsDelegate.languages[index].name,
                                                style: Styles.customTextStyle(fontSize: 18.0))),
                                        Visibility(
                                            visible: Constants.sharedPreferences.getString(Constants.LANGUAGE_CODE) ==
                                                AppLocalizationsDelegate.languages[index].code,
                                            child: Icon(Icons.done, color: Palette.appThemeColor))
                                      ])));
                            }))
                  ])));
        });
  }

  Widget _navDrawer() {
    var user = AuthModel.fromJson(jsonDecode(sharedPref.getString(Constants.TEACHER)));
    var isPremium = user?.premium == "y" ?? false;

    // showLog("user ====> ${user.toJson()}");

    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Palette.appThemeColor.withOpacity(0.9), Palette.appThemeLightColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                _profileLayout(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Divider(thickness: 0.5, color: Colors.white),
                _singleDrawerItem(itemName: AppLocalizations.of(context).courseList, itemClicked: _courseListsClicked),
              //  _singleDrawerItem(itemName: AppLocalizations.of(context).notification, itemClicked: _notificationsClicked),
              //   _singleDrawerItem(itemName: AppLocalizations.of(context).messages, itemClicked: _chatClicked),
                _singleDrawerItem(itemName: AppLocalizations.of(context).wallet, itemClicked: _walletClicked),
                _singleDrawerItem(itemName: "Students List", itemClicked: _studentsClicked),
                Visibility(
                    visible: !isPremium,
                    child: _singleDrawerItem(itemName: "Become Premium Teacher", itemClicked: widget.onPremium)),
                StatefulBuilder(
                  builder: (context, innerState) {
                    return ExpansionTile(
                      trailing: Icon(!isVisible ? Icons.expand_more : Icons.expand_less, color: Colors.white),
                      title: Text("Payouts",
                          style:
                              Styles.customTextStyle(fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.white)),
                      onExpansionChanged: (value) => innerState(() => isVisible = value),
                      // childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      children: <Widget>[
                        ListTile(
                            onTap: () => gotoPayout("pending"),
                            title: Text("Pending",
                                style: Styles.customTextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.white))),
                        ListTile(
                          onTap: () => gotoPayout("completed"),
                          title: Text(
                            "Completed",
                            style: Styles.customTextStyle(
                                fontWeight: FontWeight.w400, fontSize: 17.0, color: Colors.white),
                          ),
                        )
                      ],
                    );
                  },
                ),
                Divider(
                  thickness: 0.2,
                  color: Colors.white,
                ),
                _singleDrawerItem(
                  itemName: "Support",
                  itemClicked: _supportClicked,
                ),
                _singleDrawerItem(
                  itemName: AppLocalizations.of(context).logout,
                  itemClicked: _logoutClicked,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'v1.0',
                    style: Styles.customTextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  gotoPayout(String type) {
    setState(() {
      isVisible = false;
    });
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PayoutScreen(
          type: type,
        ),
      ),
    );
  }

  Widget _profileLayout() {
    return InkWell(
      onTap: () {
        Navigator.of(context).popAndPushNamed(Routes.UPDATE_PROFILE_PAGE);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  Constants.userImage != null && Constants.userImage != '' && !Constants.userImage.contains("noimage")
                      ? NetworkImage(ApiUrls.IMAGE_URL + Constants.userImage)
                      : NetworkImage("https://www.esm.rochester.edu/uploads/NoPhotoAvailable.jpg"),
              radius: 40.0,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Constants.userName != null && Constants.userName != '' ? Constants.userName.sCap() : '',
                    style: Styles.customTextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    Constants.userEmail != null && Constants.userEmail != '' ? Constants.userEmail.toLowerCase() : '',
                    style: Styles.customTextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15.0,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _singleDrawerItem({String itemName, Function itemClicked}) {
    return InkWell(
      onTap: itemClicked,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Text(
              itemName,
              style: Styles.customTextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
                color: Colors.white,
              ),
            ),
          ),
          Divider(thickness: 0.2, color: Colors.white),
        ],
      ),
    );
  }

  Function _courseListsClicked() {
    print("CourseLists clicked");
    Navigator.of(context).pop();
    return null;
  }

  Function _notificationsClicked() {
    print("Notifications clicked");
    Navigator.of(context).pop();
    return null;
  }

  Function _walletClicked() {
//    print("Wallet clicked");
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (c) => WalletScreen()));
    return null;
  }

  Function _chatClicked() {
//    print("Chat clicked");
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(Routes.CHAT_LIST);
//    Navigator.of(context).pushNamed(Routes.CHAT_SCREEN, arguments: {
//      AppRouteArgKeys.STUDENT_ID: '1',
//      AppRouteArgKeys.STUDENT_NAME: 'Test',
//    });
    return null;
  }

  Function _logoutClicked() {
    _logoutApi();
    return null;
  }

  Function _supportClicked() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(Routes.SUPPORT);
    return null;
  }

  Function _studentsClicked() {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(Routes.STUDENTS, arguments: {AppRouteArgKeys.COURSE_ID: null});
    return null;
  }

  void _logoutApi() async {
    var response = await ApiData.logoutUser();

    if (response != null && response.status == 'true') {
      Constants.clearUser();
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.SIGN_IN, (Route<dynamic> route) => false);
    }
  }
}

class LanguageClass {
  final String label;
  final String code;

  LanguageClass(this.label, this.code);
}
