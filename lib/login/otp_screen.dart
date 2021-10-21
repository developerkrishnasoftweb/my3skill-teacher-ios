import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/login/login_page.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../localizations.dart';
import 'login_model.dart';
import 'otp_model.dart';

class OTPScreen extends StatefulWidget {
  final OTPModel data;

  const OTPScreen({Key key, this.data}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  String phoneNumber = '';
  bool valPhone;

  String otp = "";

  bool isBusy = false;

  List<TextEditingController> _controllers;
  List<FocusNode> _focusNodes;
  List<String> _pin;

  List<Widget> pins;

  AuthProvider _provider;

  @override
  void initState() {
    super.initState();
    _pin = List<String>.generate(6, (int index) => "");
    _focusNodes = List.generate(6, (int index) => FocusNode()).toList();
    _controllers = List.generate(6, (int index) => TextEditingController());
    pins = List<Widget>.generate(6, (int index) => _singlePinView(index)).toList();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AuthProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        title: "OTP",
        produceWaveTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      spacer(height: 30),
                      Image(
                        image: AssetImage(ImagesLink.IMG_OTP),
                        height: 120,
                      ),
                      spacer(height: 50),
                      pinViewWithSms(),
                      spacer(height: 20),
//                      loginWithPasswordWidget(),
                    ],
                  ),
                ),
              ),
              submitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginWithPasswordWidget() {
    return GestureDetector(
      onTap: () {
        hideKeyboard(context);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (c) => LoginPage()),
          (route) => false,
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: Center(
          child: Text(
            "Login With Password",
            style: Styles.customTextStyle(
              color: Palette.appThemeColor,
              fontSize: 20,
              textDecoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  Widget pinViewWithSms() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: pins,
      ),
    );
  }

  Widget submitButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      fontWeight: FontWeight.w600,
      text: AppLocalizations.of(context).submit,
      textSize: 18.0,
      onTap: () {
        verifyOTP();
      },
    );
  }

  void verifyOTP() async {
    showLog("entered Otp ===>> $otp");

    if (otp == null || otp.isEmpty) {
      showToast("Please enter otp sent to your mobile number");
      return;
    }

    if (otp != null && otp.length == 6 && otp == widget.data.otp.toString()) {
      setBusy(true);

      var token = await _provider.getDeviceToken();

      var user = AuthModel.fromJson(widget.data.data.toJson());

      Map map = {
        "id": user.id.toString(),
        "token": token,
        "type": Constants.devicePlatform,
      };

      var response = await _provider.addDevice(map);

      setBusy(false);

      if (response != null && response.status == "true") {
        showToast("OTP has been verified successfully!");

        _provider.setUser(user);

        sharedPref.setBool(Constants.USER_LOGGED_IN, true);

        Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME_SCREEN, (route) => false);
      } else {
        showToast(response.message);
      }
    } else {
      showToast("Authentication failed! Try entering correct OTP for successful verification!");
    }
  }

  setBusy(value) {
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      setState(() {
        isBusy = value;
      });
    });
  }

  Widget _singlePinView(int index) {
    return Flexible(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        child: TextField(
          enabled: true,
          controller: _controllers[index],
          obscureText: false,
          autofocus: false ? index == 0 : false,
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: Styles.customTextStyle(color: Palette.appThemeColor, fontSize: 20),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Palette.appThemeColor,
                width: 2.5,
              ),
            ),
          ),
          textInputAction: TextInputAction.next,
          onChanged: (String val) {
            if (val.length == 1) {
              _pin[index] = val;
              if (index != _focusNodes.length - 1) {
                _focusNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }
            } else if (val.length == 2) {
              _controllers[index].text = val.substring(0, 1);
              _pin[index] = val.substring(0, 1);
              if ((index + 1) < _controllers.length) {
                _controllers[index + 1].text = "";
                _controllers[index + 1].text = val.substring(1);
                _pin[index + 1] = val.substring(1);
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }
            } else {
              _pin[index] = "";
              if (index != 0) {
                _focusNodes[index].unfocus();
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            }

            if (_pin.indexOf("") == -1) {
              otp = _pin.join();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _controllers.forEach((element) {
      element?.dispose();
    });
  }
}
