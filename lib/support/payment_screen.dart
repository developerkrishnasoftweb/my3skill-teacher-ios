import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';

class PaymentScreen extends StatefulWidget {
  final String premium;

  const PaymentScreen({Key key, this.premium}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _buyUrl;
  String successUrl = "https://www.my3skills.com/services/payment_success";
  String failedUrl = "https://www.my3skills.com/services/payment_failed";

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;

  @override
  void initState() {
    super.initState();

    _buyUrl =
        ApiUrls.BASE_URL + "/become_premium_teacher/${sharedPref.getString(Constants.USER_ID)}";

    showLog("buy url ====>> $_buyUrl");

    flutterWebViewPlugin.close();

    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        showLog("current url ====>> $url");
        if (url == successUrl) {
          showToast("Payment success!");
          Navigator.of(context).pop("Payment Success");
        }
        if (url == failedUrl) {
          showToast(
              "Oops sorry payment failed please re-verify your account details and try again later.");
          Navigator.of(context).pop("Payment Failed");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: SafeArea(
        child: WebviewScaffold(
          url: _buyUrl,
        ),
      ),
    );
  }

  Future<bool> onBackPressed() async {
    showToast("Oop'\s Sorry Payment Failed or Cancelled!");
    flutterWebViewPlugin.close();
    return true;
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}
