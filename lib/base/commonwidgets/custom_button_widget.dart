import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';

class CustomButton extends StatelessWidget {
  final Border border;
  final Color bgColor;
  final String text;
  final double textSize;
  final Color textColor;
  final Widget prefixImage;
  final double borderRadius;
  final double verticalPadding;
  final double horizontalPadding;
  final FontWeight fontWeight;
  final onTap;

  const CustomButton({
    Key key,
    this.border,
    this.bgColor,
    this.text,
    this.textSize,
    this.textColor,
    this.prefixImage,
    this.fontWeight: FontWeight.normal,
    this.onTap,
    this.borderRadius: 2.0,
    this.verticalPadding: 15.0,
    this.horizontalPadding: 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          gradient: bgColor == null
              ? LinearGradient(
                  colors: [
                    Palette.appThemeColor,
                    Palette.appThemeLightColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                )
              : null,
          color: bgColor != null ? bgColor : null,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: prefixImage != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  prefixImage,
                  Expanded(
                    child: Text(
                      text,
                      style: Styles.customTextStyle(
                          fontSize: textSize,
                          color: textColor,
                          fontWeight: fontWeight),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  text,
                  style: Styles.customTextStyle(
                      fontSize: textSize,
                      color: textColor,
                      fontWeight: fontWeight),
                ),
              ),
      ),
    );
  }
}
