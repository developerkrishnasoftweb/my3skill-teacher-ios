import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  TextEditingController _emailController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();

  bool _emailValidate;

  String username = "";

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: BaseScaffold(
          title: AppLocalizations.of(context).forgotPassword,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenHeight * 0.05),
                  emailInstruction(),
                  SizedBox(height: screenHeight * 0.05),
                  emailLayout(),
                  SizedBox(height: screenHeight * 0.08),
                  resetPasswordButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  emailInstruction() {
    return Text(
      AppLocalizations.of(context).enterAssociateEmail,
      textAlign: TextAlign.center,
      style: Styles.customTextStyle(
        color: Palette.greyColor,
        fontSize: 14,
      ),
    );
  }

  emailLayout() {
    return TextField(
      onChanged: (changedText) {
        username = changedText;
        setState(() {
          _emailValidate = Validator.validateEmail(changedText);
        });
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
      autocorrect: false,
      cursorColor: Palette.appThemeColor,
      controller: _emailController,
      textInputAction: TextInputAction.done,
      focusNode: _emailFocusNode,
      onSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
      decoration: Styles.customTextInputDecoration(
        hintText: "Enter Mobile or Email",
        borderColor: Palette.appThemeColor,
      ),
    );
  }

  resetPasswordButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      fontWeight: FontWeight.w600,
      text: "Get Password",
      textSize: 18.0,
      onTap: () {
        callForgotPasswordAPI();
      },
    );
  }

  callForgotPasswordAPI() async {
    if (!Validator.validateText(username)) {
      showToast("Please enter email or mobile");
      return;
    }

    if (await isNetworkConnected()) {
      setLoading(true);

      var response = await ApiData.sendForgotPasswordLinkToEmail(username);

      setLoading(false);

      if (response != null && response.type == "true") {
        showToast(response.message);
        _emailController.clear();
      } else {
        showToast(Constants.SOMETHING_WENT_WRONG);
      }
    }
  }

  showToast(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
  }

  setLoading(value) {
    setState(() {
      isLoading = value;
    });
  }
}
