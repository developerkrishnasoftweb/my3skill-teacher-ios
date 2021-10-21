import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/apis/api_url.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/mixins/after_build.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage>
    with AfterLayoutMixin<UpdateProfilePage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool isLoading = false;

  File pickedImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController tagLineController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController faceBookController = TextEditingController();
  TextEditingController linkedInController = TextEditingController();
  TextEditingController youTubeController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode tagLineFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode tagsFocusNode = FocusNode();
  FocusNode twitterFocusNode = FocusNode();
  FocusNode faceBookFocusNode = FocusNode();
  FocusNode linkedInFocusNode = FocusNode();
  FocusNode youTubeFocusNode = FocusNode();

  String teacherName = '',
      tagLine = '',
      description = '',
      tags = '',
      twitter = '',
      facebook = '',
      linkedIn = '',
      youTube = '',
      image = '';

  AuthProvider _provider;

  @override
  void afterFirstLayout(BuildContext context) {
    if (_provider.user != null) {
      setUserData(_provider.user);
    }
    _getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    _provider = Provider.of<AuthProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        title: AppLocalizations.of(context).updateProfile,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _getProfileLayout(),
      ),
    );
  }

  Widget _getProfileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          _getProfileImage(),
          _spacingWidget(height: 0.04),
          _getTeacherName(),
          _spacingWidget(),
          _getTagLine(),
          _spacingWidget(),
          _getDescription(),
          _spacingWidget(),
          _getTags(),
          _spacingWidget(),
          _getTwitter(),
          _spacingWidget(),
          _getFaceBook(),
          _spacingWidget(),
          _getLinkedIn(),
          _spacingWidget(),
          _getYouTube(),
          _spacingWidget(),
          _doneButton(),
          _spacingWidget(),
        ],
      ),
    );
  }

  Widget _spacingWidget({double height: 0.02}) {
    return SizedBox(height: screenHeight * height);
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

  Widget _getProfileImage() {
    return InkWell(
      onTap: () async {
        final picked = await ImagePicker().getImage(
          source: ImageSource.gallery,
          imageQuality: 90,
        );

        pickedImage = File(picked.path);

        print("The image path is : ${pickedImage.path}");
        setState(() {});
      },
      child: CircleAvatar(
        backgroundImage: pickedImage != null
            ? FileImage(pickedImage)
            : image != ''
                ? NetworkImage('${ApiUrls.IMAGE_URL}$image')
                : AssetImage(ImagesLink.PLACEHOLDER),
        radius: 60.0,
      ),
    );
  }

  Widget _getTeacherName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).teacherName,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            teacherName = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: nameController,
          textInputAction: TextInputAction.next,
          focusNode: nameFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(tagLineFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getTagLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).tagLine,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            tagLine = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: tagLineController,
          textInputAction: TextInputAction.next,
          focusNode: tagLineFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(descriptionFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).description,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            description = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: descriptionController,
          textInputAction: TextInputAction.next,
          focusNode: descriptionFocusNode,
          maxLines: 5,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(tagsFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
            borderColor: Palette.appThemeDarkColor,
            padding: EdgeInsets.only(top: 5, bottom: 15),
          ),
        ),
      ],
    );
  }

  Widget _getTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).tags,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            tags = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: tagsController,
          textInputAction: TextInputAction.next,
          focusNode: tagsFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(twitterFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getTwitter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).twitterUrl,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            twitter = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: twitterController,
          textInputAction: TextInputAction.next,
          focusNode: twitterFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(faceBookFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getFaceBook() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).facebookUrl,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            facebook = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: faceBookController,
          textInputAction: TextInputAction.next,
          focusNode: faceBookFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(linkedInFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getLinkedIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).linkedInUrl,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            linkedIn = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: linkedInController,
          textInputAction: TextInputAction.next,
          focusNode: linkedInFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).requestFocus(youTubeFocusNode);
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _getYouTube() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).youtubeUrl,
          fontSize: 15.0,
        ),
        TextField(
          onChanged: (changedText) {
            youTube = changedText;
          },
          textAlign: TextAlign.start,
          keyboardType: TextInputType.text,
          style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
          autocorrect: false,
          cursorColor: Palette.appThemeDarkColor,
          controller: youTubeController,
          textInputAction: TextInputAction.done,
          focusNode: youTubeFocusNode,
          onSubmitted: (_) {
            FocusScope.of(context).unfocus();
          },
          decoration: Styles.customTextInputDecoration(
              borderColor: Palette.appThemeDarkColor, contentPadding: 0.0),
        ),
      ],
    );
  }

  Widget _doneButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: AppLocalizations.of(context).update,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: doneClicked,
    );
  }

  void doneClicked() {
    _updateProfile();
  }

  void _getProfileDetails() async {
    setBusy(true);
    var response = await _provider.getUserProfile();

    if (response != null) {
      setUserData(response);
      setBusy(false);
    } else {
      setBusy(false);
      showToast('Unable to load the profile');
    }
  }

  setUserData(AuthModel response) {
    nameController.text = response.name ?? '';
    tagLineController.text = response.tagline ?? '';
    descriptionController.text = response.description ?? '';
    tagsController.text = response.tags ?? '';
    twitterController.text = response.twitter ?? '';
    faceBookController.text = response.facebook ?? '';
    linkedInController.text = response.linkedin ?? '';
    youTubeController.text = response.youtube ?? '';

    teacherName = response.name ?? '';
    tagLine = response.tagline ?? '';
    description = response.description ?? '';
    tags = response.tags ?? '';
    twitter = response.twitter ?? '';
    facebook = response.facebook ?? '';
    linkedIn = response.linkedin ?? '';
    youTube = response.youtube ?? '';
    image = response.image ?? '';

    setBusy(false);
  }

  void _updateProfile() async {
    setBusy(true);

    Map<String, dynamic> userMap = {
      'name': teacherName,
      'teacher': Constants.userId,
      'tagline': tagLine,
      'description': description,
      'tags': tags,
      'twitter': twitter,
      'facebook': facebook,
      'linkedin': linkedIn,
      'youtube': youTube,
      'image': pickedImage != null
          ? await MultipartFile.fromFile(
              pickedImage.path,
              filename: pickedImage.path.split("/").last.trim().toString() ?? "image.png",
            )
          : null,
    };
    print("The mapping : $userMap}");

    var response = await ApiData.updateProfile(userMap);

    if (response != null && response.status == Constants.TRUE) {
      setBusy(false);
      showToast('Profile updated successfully.');
      Constants.sharedPreferences.setString(Constants.USER_NAME, response.name ?? '');
      Constants.userName = response.name ?? '';
      Constants.sharedPreferences.setString(Constants.USER_IMAGE, response.image ?? '');
      Constants.userImage = response.image ?? '';
    } else {
      setBusy(false);
      showToast(response.message != null && response.message != ''
          ? response.message
          : 'Something went wrong while updating profile. Please try again later.');
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
}
