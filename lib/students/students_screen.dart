import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/cached_image.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/text_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/students/students_m.dart';

class MyStudentsScreen extends StatefulWidget {
  final StreamController<String> upwardsCom;

  final String courseId;


  const MyStudentsScreen({Key key, this.upwardsCom, this.courseId}) : super(key: key);

  @override
  _MyStudentsScreenState createState() => _MyStudentsScreenState();
}

class _MyStudentsScreenState extends State<MyStudentsScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<Students> students = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMyStudents(widget.courseId);
    showLog("Constants.userId ======>> ${Constants.userId}");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      child: studentsListLayout(),
      title: "Students",
      produceWaveTitle: true,
      showLanguage: widget.upwardsCom != null,
      upwards: widget.upwardsCom,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget studentsListLayout() {
    return Column(
      children: <Widget>[
        Expanded(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Palette.appThemeColor),
                  ),
                )
              : students != null && students.isNotEmpty
                  ? ListView.builder(
                      itemCount: students.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return _singleCourseItem(students[index]);
                      },
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context).noCourse,
                        style: Styles.customTextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _singleCourseItem(Students student) {
    return ListTile(
      leading: CachedImage(ApiUrls.IMAGE_URL + student.image),
      title: Texts(
        student.name.sCap(),
        color: Palette.blackColor,
        fontSize: 18,
        fontFamily: semiBold,
      ),
      subtitle: Texts(
        student.email,
        color: Palette.greyColor,
        fontSize: 14,
      ),
    );
  }

  void getMyStudents(String courseId) async {
    setState(() {
      isLoading = true;
    });

    String userId = Constants.userId;
    if (userId == null || userId == '') return;
    StudentsM response = await ApiData.getMyStudent(courseId);

    if (response != null && response.status == 'true') {
      if (response.students != null && response.students.isNotEmpty) {
        students = response.students;
      }
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG);
    }

    setState(() {
      isLoading = false;
    });
  }
}
