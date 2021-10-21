import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';

import '../global.dart';

class Styles {
  static customTextStyle({
    Color color: Colors.black,
    FontWeight fontWeight: FontWeight.normal,
    double fontSize: 14.0,
    TextDecoration textDecoration: TextDecoration.none,
    double letterSpacing,
    String fontFamily = regular,
  }) {
    return TextStyle(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      decoration: textDecoration,
      letterSpacing: letterSpacing,
    );
  }

  static customTextInputDecoration({
    Color borderColor: Colors.white,
    Color fillColor: Colors.white,
    String errorText,
    String hintText: '',
    String labelText,
    double contentPadding: 12.0,
    EdgeInsets padding,
  }) {
    return InputDecoration(
      contentPadding: padding ?? EdgeInsets.all(contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorText: errorText,
      errorStyle: customTextStyle(fontSize: 12.0, color: Palette.lightRedColor),
      hintText: hintText,
      hintStyle: customTextStyle(
        color: Palette.appThemeColor,
        fontSize: 14.0,
      ),
      labelText: labelText,
      labelStyle: customTextStyle(
        color: Palette.appThemeColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  static customTextInputDecorationWithCustomBorders(
      {Color borderColor: Colors.white,
      Color fillColor: Colors.white,
      String errorText,
      String hintText: '',
      Color hintColor: Palette.appThemeColor,
      double contentPadding: 11.0}) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      hintText: hintText,
      hintStyle: customTextStyle(
        color: hintColor,
        fontSize: 15.0,
      ),
      labelText: hintText,
      labelStyle: customTextStyle(
        color: Palette.appThemeColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }

  static customTextInputDecorationWithSuffix({
    Color borderColor: Colors.white,
    Color fillColor: Colors.white,
    String errorText,
    String hintText: '',
    Color hintColor: Palette.appThemeColor,
    Widget suffix,
    int type: 1,
    bool labelText: true,
    double contentPadding = 15.0,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: contentPadding, horizontal: contentPadding),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2.5),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      errorText: errorText,
      errorStyle: customTextStyle(fontSize: 12.0, color: Palette.lightRedColor),
      suffix: type == 0 ? null : suffix,
      suffixIcon: type == 0 ? suffix : null,
      hintText: hintText,
      hintStyle: customTextStyle(
        color: hintColor,
        fontSize: 15.0,
      ),
      labelText: labelText ? hintText : null,
      labelStyle: customTextStyle(
        color: Palette.appThemeColor,
        fontSize: 16.0,
      ),
      filled: true,
      fillColor: fillColor,
    );
  }
}
