import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class AddFilesPage extends StatefulWidget {
  final String videoId;
  final int type;

  const AddFilesPage({Key key, this.videoId, this.type}) : super(key: key);

  @override
  _AddFilesPageState createState() => _AddFilesPageState();
}

class _AddFilesPageState extends State<AddFilesPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  File pickedFile;

  bool isLoading = false;
  TextEditingController resourcesTitleController = TextEditingController();
  FocusNode resourcesTitleNode = FocusNode();
  String resourcesTitle = '';

  bool _resourcesTitleValidate;

  @override
  void dispose() {
    super.dispose();

    resourcesTitleController.dispose();
    resourcesTitleNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        child: _getAddResourcesLayout(),
        title: widget.type == 0 ? AppLocalizations.of(context).addResource : AppLocalizations.of(context).addSubtitles,
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

  Widget _getAddResourcesLayout() {
    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              resourcesTitleLayout(),
              _resourceFileLayout(),
              Spacer(),
              _doneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text({
    String text: '',
    double fontSize: 15.0,
    Color fontColor: Palette.appThemeDarkColor,
    FontWeight fontWeight: FontWeight.normal,
  }) {
    return Text(
      text,
      style: Styles.customTextStyle(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }

  Widget resourcesTitleLayout() {
    String errorText = (_resourcesTitleValidate == null || resourcesTitle.isEmpty || _resourcesTitleValidate)
        ? null
        : widget.type == 0
            ? AppLocalizations.of(context).resourceTitleError
            : AppLocalizations.of(context).subTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: widget.type == 0
              ? AppLocalizations.of(context).resource.wordCap()
              : AppLocalizations.of(context).subtitle.wordCap(),
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            resourcesTitle = changedText;
            setState(() {
              _resourcesTitleValidate = Validator.validateText(changedText);
            });
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: resourcesTitleController,
          textInputAction: TextInputAction.next,
          focusNode: resourcesTitleNode,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration:
              Styles.customTextInputDecoration(borderColor: Palette.appThemeDarkColor, errorText: errorText, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _resourceFileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 15.0),
        _text(
          text: widget.type == 0 ? AppLocalizations.of(context).videoResource : AppLocalizations.of(context).videoSubtitles,
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
              if (widget.type == 0) {
                final result = await FilePicker.platform.pickFiles();
                if (result != null) {
                  pickedFile = File(result.paths.first);
                }
              } else {
                final result = await FilePicker.platform.pickFiles(
                  allowedExtensions: ['srt', 'sub', 'sbv', 'vtt'],
                  type: FileType.custom,
                );
                if (result != null) {
                  pickedFile = File(result.paths.first);
                }
              }
//              print(
//                  "The picked file is : ${pickedFile != null ? pickedFile.path : ''}");

              setState(() {});
            },
            child: Container(
              height: screenHeight * 0.2,
              width: screenWidth * 0.8,
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
                        ? widget.type == 0
                            ? AppLocalizations.of(context).uploadVideo
                            : AppLocalizations.of(context).uploadSubtitle
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
    print("done button clicked...");
    _submitResources();
  }

  void _submitResources() async {
    if (resourcesTitleController.text == '') {
      showToast(widget.type == 0 ? Constants.RESOURCE_TITLE_ERROR : Constants.SUBTITLES_TITLE_ERROR);
      return;
    }

    if (pickedFile == null) {
      showToast('Please pick the file first.');
    }

    _startLoading();

    Map<String, dynamic> filesMap = {
      'video': widget.videoId,
      'title': resourcesTitleController.text ?? '',
      'file': await MultipartFile.fromFile(
        pickedFile.path,
        filename: pickedFile.path.split('/').last.toString() ?? 'image.png',
      ),
    };

    var response = widget.type == 0 ? await ApiData.addResources(filesMap) : await ApiData.addSubtitles(filesMap);

    if (response != null && response.status == 'true') {
      _stopLoading();
      Navigator.of(context).pop('Success');
    } else {
      _stopLoading();
      showToast(response.message != null ? response.message : 'Something went wrong in uploading data.');
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
