import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/MyBehavior.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/my_utils.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:my3skill_teacher_ios/signup/sign_up_page.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameCntrl = TextEditingController();

  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _usernameFN = FocusNode();

  bool valPassword;
  bool valEmail, valPhone;
  bool showPassword = false;

  String password = '', username = '';

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  AuthProvider _provider;

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameCntrl.dispose();
    _passwordFocusNode.dispose();
    _usernameFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    _provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: ModalProgressHUD(
          inAsyncCall: _provider.isBusy,
          child: BaseScaffold(
            title: AppLocalizations.of(context).login,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: <Widget>[
                topLayout(),
                bottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget topLayout() {
    return Column(children: <Widget>[
      userNameTextField(),
      SizedBox(height: screenHeight * 0.02),
      passwordLayout(),
      SizedBox(height: screenHeight * 0.02),
      emailMeLayout(),
      SizedBox(height: screenHeight * 0.04),
      loginButton(),
      SizedBox(height: screenHeight * 0.04),
      orWidget(),
      SizedBox(height: screenHeight * 0.04),
      mobileButton(),
      spacer(height: 30)
    ]);
  }

  Widget orWidget() {
    return Visibility(
        visible: Platform.isAndroid,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(children: <Widget>[
              Expanded(child: Divider(color: Colors.black26, height: 1, thickness: 1)),
              Text(AppLocalizations.of(context).or.sCap().toUpperCase(),
                  style: Styles.customTextStyle(color: Colors.grey)),
              Expanded(child: Divider(color: Colors.black26, height: 1, thickness: 1))
            ])));
  }

  Widget googleButton() {
    return CustomButton(
        horizontalPadding: 30,
        prefixImage: Image.asset(
          ImagesLink.GOOGLE_ICON,
          height: 25,
          width: 25,
        ),
        borderRadius: 30,
        textColor: Colors.black54,
        text: AppLocalizations.of(context).loginGoogle,
        textSize: 18.0,
        bgColor: Palette.lightGreyColor,
        fontWeight: FontWeight.w600,
        onTap: _googleButtonClicked);
  }

  Widget facebookButton() {
    return CustomButton(
        horizontalPadding: 30,
        prefixImage: Image.asset(
          ImagesLink.FB_ICON,
          height: 30,
        ),
        borderRadius: 30,
        textColor: Colors.white,
        text: AppLocalizations.of(context).loginFacebook,
        textSize: 18.0,
        bgColor: Palette.fbColor,
        fontWeight: FontWeight.w600,
        onTap: _fbButtonClicked);
  }

  Widget mobileButton() {
    return Visibility(
        visible: Platform.isAndroid,
        child: CustomButton(
            borderRadius: 30,
            textColor: Colors.white,
            fontWeight: FontWeight.w600,
            text: "Request OTP",
            textSize: 18.0,
            onTap: () => sendOTP()));
  }

  Widget bottomBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        spacer(height: 40),
        Text("Don\'t have an account yet?",
            style: Styles.customTextStyle(color: Colors.black54, fontSize: 16.0, fontFamily: semiBold)),
        spacer(height: 10),
        GestureDetector(
            onTap: () {
              hideKeyboard(context);
              Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpPage()));
            },
            child: Text(AppLocalizations.of(context).register,
                style:
                    Styles.customTextStyle(color: Palette.appThemeColor, fontSize: 18.0, fontWeight: FontWeight.bold))),
        spacer(height: 20),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: AppLocalizations.of(context).privacyPolicy,
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontSize: 14.0,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      hideKeyboard(context);
                      Utils.launchUrl(Constants.PRIVACY_POLICY_URL);
                    }),
              TextSpan(text: ' | ', style: Styles.customTextStyle(color: Palette.appThemeColor, fontSize: 14.0)),
              TextSpan(
                  text: "Terms and Conditions",
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontSize: 14.0,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      hideKeyboard(context);
                      Utils.launchUrl(Constants.TERMS_CONDITIONS);
                    }),
              TextSpan(text: ' | ', style: Styles.customTextStyle(color: Palette.appThemeColor, fontSize: 14.0))
            ])),
        spacer(height: 10),
        Text(
          "My3Skills Use Policy @ 2020. All rights reserved.",
          style: Styles.customTextStyle(
            color: Colors.black54,
            fontSize: 14.0,
            fontFamily: semiBold,
          ),
        ),
      ],
    );
  }

  Widget userNameTextField() {
    return TextField(
      onChanged: (newText) {
        username = newText;
        valEmail = Validator.validateEmail(username);
        valPhone = Validator.phoneValidator(username);
        setState(() {});
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _usernameCntrl,
      textInputAction: TextInputAction.next,
      focusNode: _usernameFN,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      decoration: Styles.customTextInputDecoration(
        hintText: "Enter Mobile or Email",
        labelText: "Enter Mobile or Email",
        borderColor: Palette.appThemeColor,
      ),
    );
  }

  Widget passwordLayout() {
    Widget suffix = GestureDetector(
      onTap: () => setState(() => showPassword = !showPassword),
      child:
          showPassword ? Icon(Icons.visibility, color: Colors.black) : Icon(Icons.visibility_off, color: Colors.black),
    );

    String errorText =
        (valPassword == null || password.isEmpty || valPassword) ? null : AppLocalizations.of(context).validPassword;

    return TextField(
      onChanged: (changedText) {
        password = changedText;
        setState(() {
          valPassword = Validator.validatePassword(changedText);
        });
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      cursorColor: Palette.appThemeColor,
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      obscureText: !showPassword,
      focusNode: _passwordFocusNode,
      onSubmitted: (_) {
        hideKeyboard(context);
      },
      decoration: Styles.customTextInputDecorationWithSuffix(
        hintText: AppLocalizations.of(context).password,
        borderColor: Palette.appThemeColor,
        type: 0,
        suffix: suffix,
        errorText: errorText,
      ),
    );
  }

  Widget emailMeLayout() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          hideKeyboard(context);
          Navigator.of(context).pushNamed(Routes.FORGET_PASSWORD);
        },
        child: Text(
          AppLocalizations.of(context).forgotPassword2,
          style: Styles.customTextStyle(color: Palette.greyColor, textDecoration: TextDecoration.underline),
        ),
      ),
    );
  }

  Widget loginButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: AppLocalizations.of(context).login,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: _loginButtonClicked,
    );
  }

  Future<void> _loginButtonClicked() async {
    hideKeyboard(context);

    if (!Validator.validateText(username)) {
      showToast("Please enter email or mobile");
      return;
    }

    if (!Validator.validatePassword(password)) {
      showToast(AppLocalizations.of(context).validPassword);
      return;
    }

    hideKeyboard(context);

    Map map = {
      "username": valPhone ? "91" + username : username,
      "password": password,
      "type": Constants.devicePlatform,
    };

    var response = await _provider.loginUser(map);
    if (response != null && response.response == "true") {
      gotoHome(response);
    } else {
      showToast(response != null ? response.message : Constants.SOMETHING_WENT_WRONG);
    }
  }

  gotoHome(response) {
    _provider.getUserProfile();
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME_SCREEN, (_) => false);
  }

  void sendOTP() async {
    if (valPhone == null || !valPhone) {
      showToast("Please enter valid mobile number");
      return;
    }

    hideKeyboard(context);

    _provider.setBusy(true);

    var response = await _provider.sendOTP(username);

    _provider.setBusy(false);

    if (response != null && response.status == "true") {
      gotoOtpScreen(response);
    } else {
      showToast(response != null ? response.message : "Sorry there is no user associated with this mobile number!");
    }
  }

  gotoOtpScreen(response) {
    showToast("OTP has been sent successfully!");
    Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(data: response)));
  }

  _fbButtonClicked() async {
    var user = await _provider.signInWithFacebook();
    if (user != null) {
      Navigator.of(context)
          .pushNamed(Routes.SIGN_UP, arguments: {AppRouteArgKeys.USER: user, AppRouteArgKeys.SOCIAL_TYPE: "facebook"});
    }
  }

  _googleButtonClicked() async {
    var user = await _provider.signInWithGoogle();
    if (user != null) {
      Navigator.of(context).pushNamed(
        Routes.SIGN_UP,
        arguments: {AppRouteArgKeys.USER: user, AppRouteArgKeys.SOCIAL_TYPE: "google"},
      );
    }
  }
}
