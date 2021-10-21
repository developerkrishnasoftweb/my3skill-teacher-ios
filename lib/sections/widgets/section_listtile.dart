import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/sections/models/models.dart';

Widget sectionTile<T>(CourseSections courseSection, BuildContext context,
    {Function callBack, VoidCallback onDelete, VoidCallback onUpdate}) {
  final int videoCount = courseSection?.videos?.length ?? 0;
  if (callBack == null) {
    callBack = (value) {};
  }
  return ListTile(
    onTap: () {
      Navigator.of(context).pushNamed<T>(Routes.VIDEOS_PAGE, arguments: {
        AppRouteArgKeys.SECTION: courseSection,
      }).then((value) => callBack(value));
    },
    title: Row(
      children: [
        Flexible(
          child: Text(courseSection.title,
              style: Styles.customTextStyle(
                fontSize: 17.0,
                color: Palette.blackColor,
                fontFamily: semiBold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey, borderRadius: BorderRadius.circular(5)),
          child: Text('$videoCount',
              style: Styles.customTextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontFamily: bold,
              )),
        ),
      ],
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: onUpdate,
            splashRadius: 25,
            iconSize: 20),
        IconButton(
            icon: Icon(Icons.delete_outline_rounded),
            onPressed: onDelete,
            splashRadius: 25,
            iconSize: 20),
      ],
    ),
  );
}
