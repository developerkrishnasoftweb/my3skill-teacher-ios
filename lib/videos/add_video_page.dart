import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/forgot_password/common_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class AddVideoPage extends StatefulWidget {
  final String courseId;
  final String sectionId;

  const AddVideoPage({Key key, this.courseId, this.sectionId}) : super(key: key);

  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String courseTitle = '', courseDescription = '', price = '', _coursePosition = '';

  FocusNode courseTitleNode = FocusNode();
  FocusNode courseDescriptionNode = FocusNode();
  FocusNode priceNode = FocusNode();

  bool _courseTitleValidate;
  bool _courseDescriptionValidate;
  bool _priceValidate;
  bool _coursePositionValidate;

  File pickedFile, pickedVideo;

  bool isLoading = false;

  String _path;
  Map<String, String> _paths;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        child: _addVideoLayout(),
        title: AppLocalizations.of(context).addVideo,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  Widget _addVideoLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: <Widget>[
          courseTitleLayout(),
          _spacingWidget(),
          _positionsLayout(),
          _spacingWidget(),
//          courseDescriptionLayout(),
//          _spacingWidget(),
//          priceLayout(),
//          _spacingWidget(),
          _courseImageLayout(),
          _spacingWidget(),
          _promoVideoLayout(),
          _spacingWidget(),
          _doneButton(),
        ],
      ),
    );
  }

  Widget _spacingWidget() {
    return SizedBox(height: screenHeight * 0.02);
  }

  Widget _text({
    String text: '',
    double fontSize: 15.0,
    Color fontColor: Palette.appThemeDarkColor,
    FontWeight fontWeight: FontWeight.normal,
  }) {
    return Text(text,
        style: Styles.customTextStyle(fontWeight: fontWeight, color: fontColor, fontSize: fontSize),
        overflow: TextOverflow.ellipsis);
  }

  Widget courseTitleLayout() {
    String errorText = (_courseTitleValidate == null || courseTitle.isEmpty || _courseTitleValidate)
        ? null
        : AppLocalizations.of(context).courseTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: "Video Title",
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            courseTitle = changedText;
            setState(() {
              _courseTitleValidate = Validator.validateText(changedText);
            });
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          textInputAction: TextInputAction.next,
          focusNode: courseTitleNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(courseDescriptionNode);
          },
          decoration:
              Styles.customTextInputDecoration(borderColor: Palette.appThemeDarkColor, errorText: errorText, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _positionsLayout() {
    String errorText = (_coursePositionValidate == null || _coursePosition.isEmpty || _coursePositionValidate)
        ? null
        : AppLocalizations.of(context).coursePositionError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: "Video Position",
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            _coursePosition = changedText;
            setState(() {
              _coursePositionValidate = Validator.validateText(changedText);
            });
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          textInputAction: TextInputAction.next,
          decoration:
              Styles.customTextInputDecoration(borderColor: Palette.appThemeDarkColor, errorText: errorText, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget courseDescriptionLayout() {
    String errorText = (_courseDescriptionValidate == null || courseDescription.isEmpty || _courseDescriptionValidate)
        ? null
        : AppLocalizations.of(context).courseDescError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).courseDescription,
          fontSize: 15.0,
        ),
        _spacingWidget(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (changedText) {
              courseDescription = changedText;
              setState(() {
                _courseDescriptionValidate = Validator.validateText(changedText);
              });
            },
            maxLines: 8,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            textInputAction: TextInputAction.next,
            focusNode: courseDescriptionNode,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
              contentPadding: 5.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget priceLayout() {
    String errorText =
        (_priceValidate == null || price.isEmpty || _priceValidate) ? null : AppLocalizations.of(context).coursePriceError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).coursePrice,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            price = changedText;
            setState(() {
              _priceValidate = Validator.validateText(changedText);
            });
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.number,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          textInputAction: TextInputAction.done,
          focusNode: priceNode,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: Styles.customTextInputDecoration(
            borderColor: Palette.blackColor,
            errorText: errorText,
            contentPadding: 5.0,
          ),
        ),
      ],
    );
  }

  Widget _courseImageLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: "Video Thumbnail",
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
              _selectImage();
            },
            child: Container(
              height: screenHeight * 0.25,
              width: screenWidth,
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
                    text: pickedFile == null
                        ? AppLocalizations.of(context).uploadImage
                        : pickedFile.path.split('/').last.toString(),
                    fontWeight: FontWeight.w500,
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

  Widget _promoVideoLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: "Lecture Video",
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        SizedBox(height: screenHeight * 0.01),
        DottedBorder(
          borderType: BorderType.Rect,
          dashPattern: [3],
          color: Palette.greyColor,
          child: InkWell(
            onTap: () {
              _selectVideo();
            },
            child: Container(
              height: screenHeight * 0.25,
              width: screenWidth,
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
                    text: pickedVideo == null
                        ? AppLocalizations.of(context).uploadVideo
                        : pickedVideo.path.split('/').last.toString(),
                    fontWeight: FontWeight.w500,
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
      _paths = null;
      final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickedFile != null) {
        _path = pickedFile.paths.first;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : "...";
      pickedFile = File(_path);
    });

    showLog("_selectImage name =====>> $_fileName");
    showLog("_selectImage path ======>> $_path");
  }

  void _selectVideo() async {
    String _fileName;
    try {
      _paths = null;
      final pickedFile = await FilePicker.platform.pickFiles(type: FileType.image);
      if (pickedFile != null) {
        _path = pickedFile.paths.first;
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
    setState(() {
      _fileName = _path != null ? _path.split('/').last : "...";
      pickedVideo = File(_path);
    });

    showLog("_selectVideo name =====>> $_fileName");
    showLog("_selectVideo path ======>> $_path");
  }

  Widget _doneButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: AppLocalizations.of(context).submit,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: doneClicked,
    );
  }

  void doneClicked() {
    _submitVideo();
  }

  void _submitVideo() async {
    if (courseTitle == '') {
      showToast('Please enter the video title');
      return;
    }

    if (pickedFile == null) {
      showToast('Please pick an image');
      return;
    }

    if (pickedVideo == null) {
      showToast('Please pick a video');
      return;
    }

    _startLoading();

    Map<String, dynamic> courseMap = {
      'course': widget.courseId,
      'section': widget.sectionId,
      'title': courseTitle,
      'description': "",
      'teacher': Constants.userId,
      'price': "",
      'position': _coursePosition,
      'thumb': await MultipartFile.fromFile(
        pickedFile.path,
        filename: pickedFile.path.split('/').last.trim().toString() ?? 'image.png',
      ),
      'video': await MultipartFile.fromFile(
        pickedVideo.path,
        filename: pickedVideo.path.split('/').last.trim().toString() ?? 'preview.mp4',
      ),
    };

    var addCourseResponseModel = await ApiData.addVideo(courseMap);

    if (addCourseResponseModel != null && addCourseResponseModel.status == 'true') {
      _stopLoading();
      showToast('Video Added successfully.');
      Navigator.of(context).pop<CommonModel>(addCourseResponseModel);
    } else {
      _stopLoading();
      showToast(addCourseResponseModel.message != null
          ? addCourseResponseModel.message
          : 'Something went wrong. Please try again later.');
    }
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
