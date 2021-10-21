import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPref;

const regular = "Raleway-Regular";
const medium = "Raleway-Medium";
const semiBold = "Raleway-SemiBold";
const bold = "Raleway-Bold";

Widget text(
  String title, {
  Color color: Palette.appThemeColor,
  double fontSize: 16.0,
  String fontFamily,
  TextAlign textAlign,
  int maxLines,
  FontWeight fontWeight,
  TextDecoration textDecoration,
}) {
  return Text(
    title,
    textAlign: textAlign,
    maxLines: maxLines,
    style: Styles.customTextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      textDecoration: textDecoration,
    ),
  );
}

Widget spacer({double width: 10, double height: 10}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

Future<bool> isNetworkConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}

BuildContext appContext;

showLog(Object msg) {
  debugPrint(msg);
}

showToast(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

//String Extensions
extension StringExtension on String {
  String sCap() {
    if (this.isNotEmpty) {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } else {
      return this;
    }
  }

  String wordCap() {
    List arrayPieces = List();
    String outPut = '';
    this.split(' ').forEach((separatedWord) {
      arrayPieces.add(separatedWord);
    });

    arrayPieces.forEach((word) {
      word = "${word[0].toString().toUpperCase()}${word.toString().substring(1).toLowerCase()} ";
      outPut += word;
    });
    return outPut;
  }

  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }

  bool get isEmptyORNull => this == null || isEmpty;
}

// int Extensions
extension intExtension on int {
  String timestampToString(String formatted) {
    var format = new DateFormat(formatted ?? 'MM-dd-yy HH:mm:ss');
    var date = new DateTime.fromMillisecondsSinceEpoch(this);
    return format.format(date);
  }
}
