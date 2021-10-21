import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class ReplyQuestions extends StatefulWidget {
  final String videoId;
  final String questionId;
  final String question;

  const ReplyQuestions({Key key, this.videoId, this.questionId, this.question}) : super(key: key);

  @override
  _ReplyQuestionsState createState() => _ReplyQuestionsState();
}

class _ReplyQuestionsState extends State<ReplyQuestions> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;
  String answer = '';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).questionAnswer,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _replyLayout(),
      ),
    );
  }

  Widget _replyLayout() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
        height: screenHeight * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            questionsLayout(),
            _spacingWidget(),
            answerLayout(),
            Expanded(child: SizedBox()),
            _submitButton(),
          ],
        ),
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
    return Text(
      text,
      style: Styles.customTextStyle(
        fontWeight: fontWeight,
        color: fontColor,
        fontSize: fontSize,
      ),
    );
  }

  Widget questionsLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).question,
          fontSize: 15.0,
        ),
        _spacingWidget(),
        Container(
          width: screenWidth,
          height: 150,
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 30),
          decoration: BoxDecoration(
            color: Palette.bgGreyColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: _text(
            text: widget.question,
            fontSize: 18.0,
            fontColor: Palette.greyColor,
          ),
        ),
      ],
    );
  }

  Widget answerLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).answer,
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
              answer = changedText;
            },
            maxLines: 5,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              contentPadding: 5.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: AppLocalizations.of(context).submit,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: nextClicked,
    );
  }

  void nextClicked() async {
    print("Next button clicked...");

    if (answer == '') {
      showToast('Please enter the answer.');
      return;
    }

    _startLoading();
    Map<String, String> replyMap = {
      'question': widget.questionId,
      'answer': answer ?? '',
    };

    var response = await ApiData.replyQuestions(replyMap, widget.videoId);

    if (response != null && response.status == 'true') {
      _stopLoading();
      Navigator.of(context).pop('true');
    } else {
      _stopLoading();
      showToast('Something went wrong in posting answer. Please try again later.');
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
