import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:my3skill_teacher_ios/add_course/models/course_model.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/course_list/course_list_model.dart';
import 'package:my3skill_teacher_ios/forgot_password/common_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class AddCourseImage extends StatefulWidget {
  final CourseModel courseModel;
  final CourseData courseData;

  const AddCourseImage({Key key, this.courseModel, this.courseData}) : super(key: key);

  @override
  _AddCourseImageState createState() => _AddCourseImageState();
}

class _AddCourseImageState extends State<AddCourseImage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  CourseModel model;

  FileType _pickingType = FileType.video;

  // String _fileName = "Upload new document";
  String _path;
  Map<String, String> _paths;
  CourseData _courseData;

  @override
  void initState() {
    super.initState();
    model = widget.courseModel;
    _courseData = widget.courseData;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        // _fileName = AppLocalizations.of(context).uploadVideo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        title: AppLocalizations.of(context).addCourse,
        produceWaveTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _addCourseImageLayout(),
      ),
    );
  }

  Widget _addCourseImageLayout() {
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              _courseImageLayout(),
              SizedBox(height: screenHeight * 0.02),
              _promoVideoLayout(),
              Expanded(child: SizedBox()),
              _doneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _courseImageLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).courseImage,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        SizedBox(height: screenHeight * 0.01),
        DottedBorder(
          borderType: BorderType.Rect,
          dashPattern: [3],
          color: Palette.greyColor,
          child: InkWell(
            onTap: () async => _selectImage(),
            child: Container(
              height: screenHeight * 0.25,
              width: screenWidth * 0.8,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.cloud_upload,
                    color: Colors.grey[500],
                    size: 45.0,
                  ),
                  _text(
                    text: model.image == null
                        ? AppLocalizations.of(context).uploadImage
                        : model.image.path.split('/').last.toString(),
                    weight: FontWeight.w500,
                    fontColor: Palette.blackColor,
                    fontSize: 18.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selectImage() async {
    String _fileName;

    try {
      final pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.video);
      _paths = null;
      if (pickedFile != null) {
        _path = pickedFile.paths.first;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : "...";
      model.image = File(_path);
    });

    showLog("_selectImage name =====>> $_fileName");
    showLog("_selectImage path ======>> $_path");
  }

  void _selectVideo() async {
    String _fileName;
    try {
      final pickedFile = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.video);
      _paths = null;
      if (pickedFile != null) {
        _path = pickedFile.paths.first;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : "...";
      model.video = File(_path);
    });

    showLog("_selectVideo name =====>> $_fileName");
    showLog("_selectVideo path ======>> $_path");
  }

  Widget _promoVideoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).promotionalVideo,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        SizedBox(height: screenHeight * 0.01),
        DottedBorder(
          borderType: BorderType.Rect,
          dashPattern: [3],
          color: Palette.greyColor,
          child: InkWell(
            onTap: () async {
              _selectVideo();
            },
            child: Container(
              height: screenHeight * 0.25,
              width: screenWidth * 0.8,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.cloud_upload,
                    color: Colors.grey[500],
                    size: 45.0,
                  ),
                  _text(
                    text: model.video == null ? AppLocalizations.of(context).uploadVideo : model.video.path.split('/').last,
                    weight: FontWeight.w500,
                    fontColor: Palette.blackColor,
                    fontSize: 18.0,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _doneButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: _courseData != null ? AppLocalizations.of(context).update : AppLocalizations.of(context).submit,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: _submitCourse,
    );
  }

  Widget _text({
    String text: '',
    Color fontColor: Palette.appThemeColor,
    FontWeight weight: FontWeight.normal,
    double fontSize: 15.0,
    TextAlign align: TextAlign.center,
  }) {
    return Text(
      text,
      style: Styles.customTextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: weight,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: align,
    );
  }

  void _submitCourse() async {
    if (model.image == null || model.image.path == "") {
      showToast("Please select course cover image");
      return;
    }
    if (model.video == null || model.video.path == "") {
      showToast("Please select course preview video");
      return;
    }

    if (_courseData != null) {
      _updateCourse();
    } else {
      _addCourse();
    }
  }

  bool isBusy = false;

  setBusy(value) {
    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
      setState(() {
        isBusy = value;
      });
    });
  }

  void _updateCourse() async {
    Map<String, dynamic> courseMap = {
      'id': _courseData.id,
      'course': model.title,
      'category': model.category,
      'subcategory': model.subCategory,
      'topic': model.childCategory,
      'price': model.price,
      'discounted_price': model.discountPrice,
      'short': model.short,
      'long': model.long,
      'what_learn': model.learn,
      'includes': model.includes,
      'requirement': model.requirement,
      'language': model.language,
      'teacher': Constants.userId,
      'day_to_complete': "",
      'image': await MultipartFile.fromFile(
        model.image.path,
        filename: "image.png",
      ),
      'preview': await MultipartFile.fromFile(
        model.video.path,
        filename: "preview.mp4",
      ),
    };

    setBusy(true);

    CommonModel addCourseResponseModel = await ApiData.updateCourse(courseMap);
    setBusy(false);
    if (addCourseResponseModel != null && addCourseResponseModel.status == 'true') {
      showToast("Course added successfully.");
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME_SCREEN, (_) => false);
    } else {
      showToast(
          addCourseResponseModel != null ? addCourseResponseModel.message : 'Something went wrong. Please try again later.');
    }
  }

  void _addCourse() async {
    Map<String, dynamic> courseMap = {
      'course': model.title,
      'category': model.category,
      'subcategory': model.subCategory,
      'topic': model.childCategory,
      'price': model.price,
      'discounted_price': model.discountPrice,
      'short': model.short,
      'long': model.long,
      'what_learn': model.learn,
      'includes': model.includes,
      'requirement': model.requirement,
      'language': model.language,
      'teacher': Constants.userId,
      'day_to_complete': "",
      'image': await MultipartFile.fromFile(
        model.image.path,
        filename: "image.png",
      ),
      'preview': await MultipartFile.fromFile(
        model.video.path,
        filename: "preview.mp4",
      ),
    };
    setBusy(true);

    CommonModel addCourseResponseModel = await ApiData.addCourse(courseMap);
    setBusy(false);
    if (addCourseResponseModel != null && addCourseResponseModel.status == 'true') {
      showToast("Course added successfully.");
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.HOME_SCREEN, (_) => false);
    } else {
      showToast(
          addCourseResponseModel != null ? addCourseResponseModel.message : 'Something went wrong. Please try again later.');
    }
  }
}
