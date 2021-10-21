import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/button_widgets.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';

import 'check_status_screen.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  bool isBusy = false;

  String name, mobile, email, message;

  TextEditingController _mobileCntrl = TextEditingController();
  TextEditingController _nameCntrl = TextEditingController();
  TextEditingController _emailCntrl = TextEditingController();
  TextEditingController _messageCntrl = TextEditingController();

  FocusNode _nameFN = FocusNode();
  FocusNode _mobileFN = FocusNode();
  FocusNode _emailFN = FocusNode();
  FocusNode _msgFN = FocusNode();

  setBusy(value) {
    setState(() {
      isBusy = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        title: "Contact Us",
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            accentColor: Palette.appThemeColor,
            primaryColor: Palette.appThemeColor,
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                "Keep in touch with us",
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: bold,
                ),
              ),
              spacer(height: 20),
              nameTextField(),
              spacer(height: 20),
              mobileTextField(),
              spacer(height: 20),
              emailTextField(),
              spacer(height: 20),
              messageTextField(),
              spacer(height: 50),
              sendButton(),
              spacer(height: 20),
              statusButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameTextField() {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 15.0),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _nameCntrl,
      textInputAction: TextInputAction.next,
      focusNode: _nameFN,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_mobileFN);
      },
      decoration: new InputDecoration(
        labelText: "Name",
        isDense: true,
//        contentPadding: const EdgeInsets.only(left: 10,right: 10),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(width: 0.5),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  Widget mobileTextField() {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.phone,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 15.0),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _mobileCntrl,
      textInputAction: TextInputAction.next,
      focusNode: _mobileFN,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_emailFN);
      },
      decoration: new InputDecoration(
        labelText: "Mobile number",
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  Widget emailTextField() {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.emailAddress,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 15.0),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _emailCntrl,
      textInputAction: TextInputAction.next,
      focusNode: _emailFN,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_msgFN);
      },
      decoration: new InputDecoration(
        labelText: "E-mail",
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  Widget messageTextField() {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 15.0),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _messageCntrl,
      textInputAction: TextInputAction.done,
      focusNode: _msgFN,
      onSubmitted: (_) {
        hideKeyboard(context);
      },
      textAlignVertical: TextAlignVertical.top,
      maxLines: 5,
      decoration: new InputDecoration(
        labelText: "Your message",
        alignLabelWithHint: true,
        fillColor: Colors.white,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  Widget sendButton() {
    return CustomButton(
      borderRadius: 5,
      textColor: Colors.white,
      fontWeight: FontWeight.w600,
      text: "Generate Ticket",
      textSize: 18.0,
      verticalPadding: 18,
      onTap: () {
        contactUs();
      },
    );
  }

  Widget statusButton() {
    return BorderButton(
      borderRadius: 5,
      fontWeight: FontWeight.w600,
      hPad: 20,
      vPad: 15,
      text: "Check Ticket Status",
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CheckTicketScreen())),
    );
  }

  contactUs() async {
    var name = _nameCntrl.text;
    var mobile = _mobileCntrl.text;
    var email = _emailCntrl.text;
    var message = _messageCntrl.text;

    if (name.isEmptyORNull) {
      showToast("Sender name is required");
      return;
    }

    if (mobile.isEmptyORNull) {
      showToast("Mobile is required");
      return;
    }

    if (!Validator.phoneValidator(mobile)) {
      showToast("Please enter valid mobile number");
      return;
    }

    if (email.isEmptyORNull) {
      showToast("Email is required");
      return;
    }

    if (!Validator.validateEmail(email)) {
      showToast("Please enter valid email address");
      return;
    }

    if (message.isEmptyORNull) {
      showToast("Please enter your message");
      return;
    }

    hideKeyboard(context);
    setBusy(true);
    Map map = {
      "name": name,
      "mobile": mobile,
      "email": email,
      "message": message,
    };

    var response = await ApiData.sendMessageForSupport(map);
    setBusy(false);
    if (response != null && response.status == "true") {
      showSupportDialog(response);
    }
  }

  void showSupportDialog(response) {
    _nameCntrl.clear();
    _mobileCntrl.clear();
    _emailCntrl.clear();
    _messageCntrl.clear();
    setState(() {});
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Message sent"),
          content: Text("Your message has been submitted successfully, you will shortly receive an email on your registered"
              "email with Ticket ID."
            // "We've recorded you message successfully, you will be contacted by us very soon regarding this matter "
            //     "so that we can improve our self in future to provide better user experience."
            ,
            style: TextStyle(
              color: Palette.greyColor,
            ),
          ),
          actions: [
            FlatButton(
              child: Text("Ok, Thank you!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
//    ).then(
//      (value) => Navigator.of(context).pop(),
//    );
  }

  @override
  void dispose() {
    super.dispose();
    _nameCntrl.dispose();
    _mobileCntrl.dispose();
    _emailCntrl.dispose();
    _messageCntrl.dispose();
  }
}
