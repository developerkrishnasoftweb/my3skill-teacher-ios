import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_dropdown_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/extramodels/category_model.dart';

class MainCoursePage extends StatefulWidget {

  @override
  _MainCoursePageState createState() => _MainCoursePageState();
}

class _MainCoursePageState extends State<MainCoursePage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<Category> categoryList = List();
  List<String> categoryNameList = List();

  TextEditingController workingTitleController = TextEditingController();

  int selectedCourseType = 0;
  int selectedTimeType = 0;

  String workingTitle = '';

  @override
  void initState() {
    super.initState();
    populateCategories();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      title: 'New Course',
      child: _mainCourseLayout(),
      isDrawerVisible: false,
      produceWaveTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
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
      textAlign: align,
    );
  }

  Widget _mainCourseLayout() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: screenWidth,
      height: screenHeight,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight * 0.01),
            _text(
              text:
                  'First, let\'s find out what type of\ncourse you\'re making.',
              fontSize: 18.0,
              fontColor: Palette.blackColor,
              weight: FontWeight.w500,
            ),
            _courseTypeLayout(),
            _spacingWidget(),
            workingTitleLayout(),
            _spacingWidget(),
            categoryLayout(),
            _spacingWidget(),
            _timeLayout(),
            _spacingWidget(),
            _spacingWidget(),
            _createCourseButton(),
          ],
        ),
      ),
    );
  }

  Widget _courseTypeLayout() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 1.2,
      crossAxisSpacing: screenWidth * 0.06,
      children: <Widget>[
        _singleCourseTypeItem('Course', 0, Icons.ondemand_video),
        _singleCourseTypeItem('Practice Test', 1, Icons.note_add),
      ],
    );
  }

  Widget _spacingWidget() {
    return SizedBox(height: screenHeight * 0.02);
  }

  Widget _singleCourseTypeItem(String titleName, int index, IconData iconData) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCourseType = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
              color: selectedCourseType == index
                  ? Palette.blackColor
                  : Colors.grey[500],
              width: 1),
          color: Colors.white,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: selectedCourseType == index
                      ? Palette.blackColor
                      : Colors.grey[500],
                  size: 28.0,
                ),
                _text(
                  text: titleName,
                  weight: FontWeight.bold,
                  fontColor: selectedCourseType == index
                      ? Palette.blackColor
                      : Colors.grey[500],
                  fontSize: 18.0,
                )
              ],
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Visibility(
                visible: selectedCourseType == index,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 1.5,
                      color: Palette.blackColor,
                    ),
                  ),
                  child: Icon(
                    Icons.done,
                    color: Palette.blackColor,
                    size: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget workingTitleLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: 'How about a working title?',
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        SizedBox(height: screenHeight * 0.02),
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
              workingTitle = changedText;
            },
            maxLines: 6,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: workingTitleController,
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

  Widget categoryLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: 'Choose a category',
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedCategory,
          initialValue: 'Category',
          valuesList: categoryNameList,
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedCategory(String value) {
    print("The selected category is : $value");
    return null;
  }

  Widget _timeLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
            text: 'How much time you can spend creating your course per week?',
            fontSize: 15.0,
            fontColor: Palette.greyColor,
            align: TextAlign.left),
        _spacingWidget(),
        _timeSingleItem(0, 'I\'m very busy right now (0-2 hours)'),
        _spacingWidget(),
        _timeSingleItem(1, 'I\'ll work on this on the side (2-4 hours)'),
        _spacingWidget(),
        _timeSingleItem(2, 'I have lots of flexibility (5+ hours)'),
        _spacingWidget(),
        _timeSingleItem(3, 'I haven\'t yet decided if i have time'),
      ],
    );
  }

  Widget _timeSingleItem(int index, String itemText) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTimeType = index;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 18.0,
            height: 18.0,
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Palette.blackColor,
                width: 1.2,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == selectedTimeType
                    ? Palette.blackColor
                    : Colors.transparent,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: _text(
              text: itemText,
              weight: FontWeight.w500,
              align: TextAlign.left,
              fontColor: Palette.blackColor,
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _createCourseButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: 'Create Course',
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: createCourseClicked,
    );
  }

  void createCourseClicked() {
    print("Create course clicked...");
  }

  void populateCategories() async {
    CategoriesModel response = await ApiData.getCategories();
    categoryList.clear();
    categoryNameList.clear();
    categoryNameList.add('Category');
    if (response != null && response.category != null) {
      categoryList.addAll(response.category);
      for (int i = 0; i < categoryList.length; i++) {
        categoryNameList.add(categoryList[i].category);
      }
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG_CATEGORIES);
    }
  }
}
