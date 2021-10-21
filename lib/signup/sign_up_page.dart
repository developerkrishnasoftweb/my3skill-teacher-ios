import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/MyBehavior.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/text_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/mixins/after_build.dart';
import 'package:my3skill_teacher_ios/base/my_utils.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  UserModel user;
  String type;

  SignUpPage({Key key, this.user, this.type}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with AfterLayoutMixin<SignUpPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  FocusNode _fullNameFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  bool _fullNameValidate;
  bool _passwordValidate;
  bool _emailValidate;
  bool _phoneNumberValidate;
  bool showPassword = false;

  String fullName = '', password = '', email = '', phoneNumber = '', notify = "n";

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;

  bool show = false;
  bool isDocSelected = false;

  AuthProvider _provider;

  String _fileName = "No document selected.";
  String _path;
  Map<String, String> _paths;
  FileType _pickingType = FileType.custom;

  @override
  void dispose() {
    _fullNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _fullNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    showLog("afterFirstLayout");
    setState(() {
      if (widget.user != null && widget.type != null) {
        _fullNameController.text = widget.user.displayName;
        _emailController.text = widget.user.email;
        if (widget.type == "google") {
          _phoneNumberController.text = widget.user.phoneNumber;
        }
        fullName = _fullNameController.text;
        email = _emailController.text;
        show = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    _provider = Provider.of<AuthProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: _provider.isBusy,
      child: ScrollConfiguration(
        behavior: MyBehavior(),
        child: BaseScaffold(
          title: AppLocalizations.of(context).register,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(15),
                  shrinkWrap: true,
                  children: <Widget>[
                    topLayout(),
                  ],
                ),
              ),
              show ? bottomBar() : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget topLayout() {
    return Column(
      children: <Widget>[
        fullNameLayout(),
        SizedBox(height: screenHeight * 0.02),
        emailLayout(),
        SizedBox(height: screenHeight * 0.02),
        passwordLayout(),
        SizedBox(height: screenHeight * 0.02),
        phoneNumberLayout(),
        SizedBox(height: screenHeight * 0.025),
        _uploadDocument(),
        SizedBox(height: screenHeight * 0.02),
        emailMeLayout(),
        SizedBox(height: screenHeight * 0.04),
        registerButton(),
        SizedBox(height: screenHeight * 0.04),
        show
            ? Column(
                children: [
                  orWidget(),
                  SizedBox(height: screenHeight * 0.04),
                  googleButton(),
                  SizedBox(height: screenHeight * 0.02),
                  facebookButton(),
                ],
              )
            : SizedBox(),
      ],
    );
  }

  Widget _uploadDocument() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          _openFileExplorer();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Texts(
              "Upload Resume",
              color: Palette.appThemeColor,
              fontFamily: regular,
              fontSize: 13,
            ),
            spacer(height: 12),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: Radius.circular(3),
              color: Palette.appThemeColor,
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Texts(
                      _fileName,
                      color: Palette.appThemeColor,
                      fontSize: 15,
                      fontFamily: semiBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Transform.rotate(
                      angle: _fileName == "No document selected." ? -180.0 : 0.0,
                      child: Icon(
                        _fileName == "No document selected." ? Icons.attachment : Icons.done_all,
                        color: Palette.appThemeColor,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowedExtensions: ['doc', 'pdf', 'docx', "odt"],
      );
      if (pickedFile != null) {
        _path = pickedFile.paths.first;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + "$e");
    }
    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : "No document selected.";
    });

    showLog("name ======>> $_fileName");
    showLog("path ======>> $_path");
  }

  Widget orWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: Colors.black26, height: 1, thickness: 1)),
          Text(
            AppLocalizations.of(context).or,
            style: Styles.customTextStyle(color: Colors.grey),
          ),
          Expanded(child: Divider(color: Colors.black26, height: 1, thickness: 1)),
        ],
      ),
    );
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
      text: AppLocalizations.of(context).signUpGoogle,
      textSize: 18.0,
      bgColor: Palette.lightGreyColor,
      fontWeight: FontWeight.w600,
      onTap: _googleButtonClicked,
    );
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
      text: AppLocalizations.of(context).signUpFacebook,
      textSize: 18.0,
      bgColor: Palette.fbColor,
      fontWeight: FontWeight.w600,
      onTap: _fbButtonClicked,
    );
  }

  Widget bottomBar() {
    return Container(
      height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).alreadyRegistered,
                  style: Styles.customTextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).login,
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () => {Navigator.of(context).pushNamed(Routes.SIGN_IN)},
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: AppLocalizations.of(context).privacyPolicy,
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontSize: 14.0,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Utils.launchUrl(Constants.PRIVACY_POLICY_URL);
                    },
                ),
                TextSpan(
                  text: ' and ',
                  style: Styles.customTextStyle(
                    color: Colors.black54,
                    fontSize: 14.0,
                  ),
                ),
                TextSpan(
                  text: AppLocalizations.of(context).tAndC,
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontSize: 14.0,
                    textDecoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Utils.launchUrl(Constants.PRIVACY_POLICY_URL);
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget fullNameLayout() {
    String errorText =
        (_fullNameValidate == null || fullName.isEmpty || _fullNameValidate) ? null : AppLocalizations.of(context).validFullname;

    return TextField(
      onChanged: (changedText) {
        fullName = changedText;
        setState(() {
          _fullNameValidate = Validator.validateText(changedText);
        });
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      cursorColor: Palette.appThemeColor,
      controller: _fullNameController,
      textInputAction: TextInputAction.next,
      focusNode: _fullNameFocusNode,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_emailFocusNode);
      },
      decoration: Styles.customTextInputDecoration(
        hintText: AppLocalizations.of(context).fullName,
        borderColor: Palette.appThemeColor,
        errorText: errorText,
      ),
    );
  }

  Widget emailLayout() {
    String errorText =
        (_emailValidate == null || email.isEmpty || _emailValidate) ? null : AppLocalizations.of(context).validEmail;

    return TextField(
      onChanged: (changedText) {
        email = changedText;
        setState(() => _emailValidate = Validator.validateEmail(changedText));
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      cursorColor: Palette.appThemeColor,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
      decoration: Styles.customTextInputDecoration(
        hintText: AppLocalizations.of(context).emailAddress,
        borderColor: Palette.appThemeColor,
        errorText: errorText,
      ),
    );
  }

  Widget passwordLayout() {
    Widget suffix = GestureDetector(
      onTap: () => setState(() => showPassword = !showPassword),
      child: showPassword ? Icon(Icons.visibility, color: Colors.black) : Icon(Icons.visibility_off, color: Colors.black),
    );

    String errorText =
        (_passwordValidate == null || password.isEmpty || _passwordValidate) ? null : AppLocalizations.of(context).validPassword;

    return TextField(
      onChanged: (changedText) {
        password = changedText;
        setState(() {
          _passwordValidate = Validator.validatePassword(changedText);
        });
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.visiblePassword,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      cursorColor: Palette.appThemeColor,
      controller: _passwordController,
      textInputAction: TextInputAction.next,
      obscureText: !showPassword,
      focusNode: _passwordFocusNode,
      onSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
      decoration: Styles.customTextInputDecorationWithSuffix(
        hintText: AppLocalizations.of(context).password,
        borderColor: Palette.appThemeColor,
        type: 0,
        suffix: suffix,
        errorText: errorText,
      ),
    );
  }

  Widget phoneNumberLayout() {
    String errorText = (_phoneNumberValidate == null || phoneNumber.isEmpty || _phoneNumberValidate)
        ? null
        : AppLocalizations.of(context).validPhone;

    return Visibility(
      visible: Platform.isAndroid,
      child: TextField(
        onChanged: (changedText) {
          phoneNumber = changedText;
          setState(() => _phoneNumberValidate = Validator.phoneValidator(changedText));
        },
        textAlign: TextAlign.start,
        keyboardType: TextInputType.phone,
        style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
        autocorrect: false,
        cursorColor: Palette.appThemeColor,
        controller: _phoneNumberController,
        textInputAction: TextInputAction.done,
        focusNode: _phoneNumberFocusNode,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        decoration: Styles.customTextInputDecoration(
          hintText: AppLocalizations.of(context).phoneNumber,
          borderColor: Palette.appThemeColor,
          errorText: errorText,
        ),
      ),
    );
  }

  Widget emailMeLayout() {
    return Row(children: <Widget>[
      Checkbox(value: emailMe, onChanged: _emailMe, activeColor: Palette.appThemeColor),
      Text(AppLocalizations.of(context).emailMe, style: Styles.customTextStyle(color: Colors.black54))
    ]);
  }

  bool emailMe = false;

  void _emailMe(bool newValue) {
    setState(() {
      emailMe = newValue;
      if (emailMe) {
        notify = "y";
      } else {
        notify = "n";
      }
    });
  }

  Widget registerButton() {
    return CustomButton(
        borderRadius: 30,
        textColor: Colors.white,
        text: AppLocalizations.of(context).register,
        fontWeight: FontWeight.w600,
        textSize: 18.0,
        onTap: _registerButtonClicked);
  }

  void _registerButtonClicked() {
    if (!Validator.validateText(fullName)) {
      showToast(AppLocalizations.of(context).validFullname);
      setState(() => _fullNameValidate = false);
      return;
    }

    if (!Validator.validateEmail(email)) {
      showToast(AppLocalizations.of(context).validEmail);
      setState(() => _emailValidate = false);
      return;
    }

    if (!Validator.validatePassword(password)) {
      showToast(AppLocalizations.of(context).validPassword);
      setState(() => _passwordValidate = false);
      return;
    }

    // if (!Validator.phoneValidator(phoneNumber)) {
    //   showToast(AppLocalizations.of(context).validPhone);
    //   setState(() => _phoneNumberValidate = false);
    //   return;
    // }

    if (_path.isEmptyORNull) {
      showToast("Please select your resume to continue!");
      return;
    }

    _register();
  }

  void _register() async {
    email = _emailController.text;
    password = _passwordController.text;
    phoneNumber = _phoneNumberController.text;
    fullName = _fullNameController.text;

    var response;
    var kImage, ext;

    try {
      ext = _fileName.substring(_fileName.lastIndexOf("."));
      showLog("ext =====>> $ext");
      if (_path != null && _path.toString().isNotEmpty) {
        kImage = await MultipartFile.fromFile(_path, filename: "teacher_resume_${DateTime.now().toIso8601String()}$ext");
      }

      Map<String, dynamic> map = {
        "email": email,
        "password": password,
        "name": fullName,
        "mobile": phoneNumber,
        "notify": notify,
        "type": Constants.devicePlatform,
        "resume": kImage,
        "token": await _provider.getDeviceToken()
      };

      if (widget.user == null && widget.type == null) {
        response = await _provider.registerUser(map);
        if (response != null && response.response == "true") {
          showToast("You have registered successfully! Please wait for Admin to accept your registration!");
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.SIGN_IN, (route) => false);
        }
      } else {
        map.putIfAbsent("image_url", () => widget.user.photoUrl);
        response = await _provider.socialLogin(map);
        if (response != null && response.status == "true") {
          showToast("You have registered successfully! Please wait for Admin to accept your registration!");
          Navigator.of(context).pushNamedAndRemoveUntil(Routes.SIGN_IN, (route) => false);
        }
      }
    } catch (e) {
      print('exception ====>>> $e');
    }
  }

  Future<void> _fbButtonClicked() async {
    var response = await _provider.signInWithFacebook();
    if (response != null) {
      setState(() {
        _fullNameController.text = response.displayName;
        _emailController.text = response.email;
        _phoneNumberController.text = response.phoneNumber ?? "";
        fullName = _fullNameController.text;
        email = _emailController.text;
        _fullNameValidate = true;
        _emailValidate = true;
      });
    }
  }

  Future<void> _googleButtonClicked() async {
    var response = await _provider.signInWithGoogle();
    widget.user = response;
    if (response != null) {
      setState(() {
        _fullNameController.text = response.displayName;
        _emailController.text = response.email;
        _phoneNumberController.text = response.phoneNumber ?? "";
        fullName = _fullNameController.text;
        email = _emailController.text;
        _fullNameValidate = true;
        _emailValidate = true;
      });
    }
  }
}
