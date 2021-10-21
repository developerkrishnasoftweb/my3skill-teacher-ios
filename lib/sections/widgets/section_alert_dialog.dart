import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/sections/models/models.dart';

Future<T> alert<T>(BuildContext context,
    {bool isUpdate: false, CourseSections courseSections}) {
  String title = courseSections?.title ?? '',
      position = courseSections?.position ?? '';
  return showDialog<T>(
    context: context,
    builder: (_) => AlertDialog(
      title: isUpdate ? Text("Update Section") : Text("Add Section"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: TextEditingController(text: courseSections?.position),
            keyboardType: TextInputType.number,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Palette.greyColor)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: "Position*",
                hintStyle: TextStyle(
                    color: Palette.greyColor, fontWeight: FontWeight.bold)),
            onChanged: (v) {
              position = v;
            },
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: TextEditingController(text: courseSections?.title),
            onEditingComplete: () => Navigator.pop<Map<String, String>>(context,
                <String, String>{'position': position, 'title': title}),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: Palette.greyColor)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                hintText: "Title*",
                hintStyle: TextStyle(
                    color: Palette.greyColor, fontWeight: FontWeight.bold)),
            onChanged: (v) {
              title = v;
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Palette.lightGreyColor)),
          child: Text("CLOSE", style: TextStyle(color: Palette.greyColor)),
        ),
        TextButton(
          onPressed: () => Navigator.pop<Map<String, String>>(
              context, <String, String>{'position': position, 'title': title}),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Palette.appThemeColor)),
          child: Text(isUpdate ? "UPDATE" : "ADD",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
