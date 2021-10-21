import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/questions/get_questions_model.dart';

class QuestionsListPage extends StatefulWidget {
  final String videoId;

  const QuestionsListPage({Key key, this.videoId}) : super(key: key);

  @override
  _QuestionsListPageState createState() => _QuestionsListPageState();
}

class _QuestionsListPageState extends State<QuestionsListPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isLoading = false;
  List<QuestionsData> questions = List();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).questionsList,
        isDrawerVisible: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        child: _questionsListLayout(),
      ),
    );
  }

  Widget _questionsListLayout() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: screenHeight * 0.02),
          Expanded(
            child: questions != null && questions.length > 0
                ? ListView.builder(
                    itemCount: questions.length,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                    itemBuilder: (context, index) {
                      return _singleQuestionsItem(questions[index]);
                    },
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).noQuestions,
                      style: Styles.customTextStyle(
                        color: Palette.appThemeColor,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _singleQuestionsItem(QuestionsData questionsData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _itemData(questionsData),
        SizedBox(height: 10.0),
        Divider(height: 2, thickness: 1),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _itemData(QuestionsData questionsData) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  questionsData.question ?? '',
                  style: Styles.customTextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: Palette.blackColor,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            child: questionsData.replied == 'y'
                ? Text(
                    questionsData.answer ?? '',
                    style: Styles.customTextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0,
                      color: Palette.greyColor,
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: screenWidth * 0.3,
                      child: CustomButton(
                        onTap: () async {
                          var response = await Navigator.of(context).pushNamed(Routes.QUESTIONS_REPLY_PAGE, arguments: {
                            AppRouteArgKeys.VIDEO_ID: widget.videoId,
                            AppRouteArgKeys.QUESTION: questionsData.question,
                            AppRouteArgKeys.QUESTION_ID: questionsData.id,
                          });

                          if (response == 'true') {
                            _loadQuestions();
                          }
                        },
                        horizontalPadding: 10.0,
                        verticalPadding: 10.0,
                        text: AppLocalizations.of(context).addAnswer,
                        textColor: Colors.white,
                        bgColor: Palette.appThemeColor,
                        borderRadius: 5.0,
                        textSize: 15.0,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _loadQuestions() async {
    _startLoading();

    var response = await ApiData.getQuestions(widget.videoId);
    questions.clear();
    if (response != null && response.status == 'true' && response.questions != null) {
      questions = response.questions;
      _stopLoading();
    } else {
      _stopLoading();
      showToast('Something went wrong in fetching questions list. Please try again later.');
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
