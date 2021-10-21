import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/add_course/models/course_model.dart';
import 'package:my3skill_teacher_ios/add_course/models/language_m.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_dropdown_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/base/validator.dart';
import 'package:my3skill_teacher_ios/course_list/course_list_model.dart';
import 'package:my3skill_teacher_ios/extramodels/category_model.dart';
import 'package:my3skill_teacher_ios/extramodels/subcategories_model.dart';
import 'package:my3skill_teacher_ios/extramodels/topics_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';

class AddCoursePage extends StatefulWidget {
  final CourseData courseData;

  const AddCoursePage({Key key, this.courseData}) : super(key: key);

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String title = '',
      short = '',
      long = '',
      language = 'English',
      level = '',
      category = 'Category',
      subCategory = 'Sub Category',
      childCategory = 'Select Child Category',
      learn = '',
      price = '',
      discountedPrice = '',
      requirement = '',
      includes = '',
      days = '';

  TextEditingController titleCntrl = TextEditingController();
  TextEditingController shortCntrl = TextEditingController();
  TextEditingController descCntrl = TextEditingController();
  TextEditingController learnCntrl = TextEditingController();
  TextEditingController priceCntrl = TextEditingController();
  TextEditingController discCntrl = TextEditingController();
  TextEditingController reqCntrl = TextEditingController();
  TextEditingController includesCntrl = TextEditingController();

  FocusNode titleFN = FocusNode();
  FocusNode shortFN = FocusNode();
  FocusNode descFN = FocusNode();
  FocusNode leanFN = FocusNode();
  FocusNode priceFN = FocusNode();
  FocusNode discFN = FocusNode();
  FocusNode reqFN = FocusNode();
  FocusNode includesFN = FocusNode();

  List<Category> categoryList = List();
  List<String> categoryNameList = List();

  List<Subcategory> subCategoryList = List();
  List<String> subCategoryNameList = List();

  List<Topics> subChildList = List();
  List<String> topicsNameList = List();

  List<Languages> languagesList = List();
  List<String> languageNamesList = List();

  bool valTitle;
  bool valShort;
  bool valDesc;
  bool valLearn;
  bool valPrice;
  bool valDays;
  bool valReq;
  bool valIncludes;
  bool isFree = false;

  CourseData _courseData;

  @override
  void initState() {
    super.initState();
    _courseData = widget.courseData;
    _setValues();
    populateLanguages();
    populateCategories();
  }

  _setValues() {
    if (_courseData != null) {
      titleCntrl.text = title = _courseData.course;
      shortCntrl.text = short = _courseData.short;
      learnCntrl.text = learn = _courseData.whatLearn;
      priceCntrl.text = price = _courseData.price;
      reqCntrl.text = requirement = _courseData.requirement;
      includesCntrl.text = includes = _courseData.includes;
      descCntrl.text = long = _courseData.long;
      isFree = _courseData.price == "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return BaseScaffold(
      title: _courseData != null
          ? AppLocalizations.of(context).updateCourse
          : AppLocalizations.of(context).addCourse,
      produceWaveTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
          size: 24.0,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: _addCourseMainLayout(),
    );
  }

  Widget _addCourseMainLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            categoryLayout(),
            _spacingWidget(),
            subCategoryLayout(),
            _spacingWidget(),
            childCategoryLayout(),
            _spacingWidget(),
            languageLayout(),
            _spacingWidget(),
            courseTitleLayout(),
            _spacingWidget(),
            courseShortLayout(),
            _spacingWidget(),
            requirementLayout(),
            _spacingWidget(),
            courseDescriptionLayout(),
            _spacingWidget(),
            includesLayout(),
            _spacingWidget(),
            learnLayout(),
            _spacingWidget(),
            priceLayout(),
            _spacingWidget(),
            _nextButton(),
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

  Widget courseTitleLayout() {
    String errorText = (valTitle == null || title.isEmpty || valTitle)
        ? null
        : AppLocalizations.of(context).courseTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).courseTitle,
          fontSize: 15.0,
        ),
        spacer(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (newText) {
              title = newText;
              setState(() {
                valTitle = Validator.validateText(newText);
              });
            },
            textCapitalization: TextCapitalization.sentences,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: titleCntrl,
            textInputAction: TextInputAction.next,
            focusNode: titleFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(shortFN);
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget courseShortLayout() {
    String errorText = (valShort == null || short.isEmpty || valShort)
        ? null
        : AppLocalizations.of(context).courseSubTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).courseSubtitle,
          fontSize: 15.0,
        ),
        spacer(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (newText) {
              short = newText;
              setState(() {
                valShort = Validator.validateText(newText);
              });
            },
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: shortCntrl,
            textInputAction: TextInputAction.next,
            focusNode: shortFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget requirementLayout() {
    String errorText = (valReq == null || requirement.isEmpty || valReq)
        ? null
        : AppLocalizations.of(context).courseSubTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).requirements,
          fontSize: 15.0,
        ),
        spacer(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (newText) {
              requirement = newText;
              setState(() {
                valReq = Validator.validateText(newText);
              });
            },
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: reqCntrl,
            textInputAction: TextInputAction.next,
            focusNode: reqFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget includesLayout() {
    String errorText = (valIncludes == null || includes.isEmpty || valIncludes)
        ? null
        : AppLocalizations.of(context).courseSubTitleError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).courseIncludes,
          fontSize: 15.0,
        ),
        spacer(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (newText) {
              includes = newText;
              setState(() {
                valIncludes = Validator.validateText(newText);
              });
            },
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: includesCntrl,
            textInputAction: TextInputAction.next,
            focusNode: includesFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget courseDescriptionLayout() {
    String errorText = (valDesc == null || long.isEmpty || valDesc)
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
        spacer(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Palette.lightGreyColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: TextField(
            onChanged: (newText) {
              long = newText;
              setState(() {
                valDesc = Validator.validateText(newText);
              });
            },
            maxLines: 5,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: descCntrl,
            textInputAction: TextInputAction.next,
            focusNode: descFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus();
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget languageLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).selectLanguage,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedLanguage,
          initialValue: 'English',
          valuesList: languageNamesList,
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedLanguage(String value) {
    print("The selected language is : $value");
    print(value);
    setState(() {
      language = value;
    });
    return null;
  }

  Widget levelLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).selectLevel,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedLevel,
          initialValue: 'Beginner Level',
          valuesList: ['Beginner Level', 'Intermediate Level', 'Expert Level'],
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedLevel(String value) {
    print("The selected language is : $value");

    return null;
  }

  Widget categoryLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).chooseCategory,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedCategory,
          initialValue: category,
          valuesList: categoryNameList,
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedCategory(String value) {
    print("The selected category is : $value");
    category = value;
    if (value != 'Category') {
      for (int i = 0; i < categoryList.length; i++) {
        if (categoryList[i].category == value) {
          populateSubCategories(categoryList[i].id);
          break;
        }
      }
    }
    return null;
  }

  Widget subCategoryLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).chooseSubCategory,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedSubCategory,
          initialValue: subCategory,
          valuesList: subCategoryNameList,
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedSubCategory(String value) {
    print("The selected sub category is : $value");
    subCategory = value;
    if (value != 'Sub Category') {
      for (int i = 0; i < subCategoryList.length; i++) {
        if (subCategoryList[i].subcategory == value) {
          populateChildCategories(subCategoryList[i].id);
          break;
        }
      }
    }
    return null;
  }

  Widget childCategoryLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).chooseTopic,
          fontSize: 15.0,
          fontColor: Palette.greyColor,
        ),
        CustomDropdownWidget(
          selectedValue: _selectedSubChild,
          initialValue: childCategory,
          valuesList: topicsNameList,
          themeColor: Colors.white,
          arrowWidget: Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  Function _selectedSubChild(String value) {
    print("The selected topic is : $value");
    childCategory = value;
    if (value != 'Topics') {
      for (int i = 0; i < subChildList.length; i++) {
        if (subChildList[i].topic == value) {
          break;
        }
      }
    }
    return null;
  }

  Widget learnLayout() {
    String errorText = (valLearn == null || learn.isEmpty || valLearn)
        ? null
        : AppLocalizations.of(context).whatLearnError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _text(
          text: AppLocalizations.of(context).whatLearn,
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
            onChanged: (newText) {
              learn = newText;
              setState(() {
                valLearn = Validator.validateText(newText);
              });
            },
            maxLines: 5,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.text,
            style: Styles.customTextStyle(color: Colors.black, fontSize: 18.0),
            autocorrect: false,
            cursorColor: Palette.appThemeDarkColor,
            controller: learnCntrl,
            textInputAction: TextInputAction.next,
            focusNode: leanFN,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(priceFN);
            },
            decoration: Styles.customTextInputDecoration(
              borderColor: Colors.transparent,
              errorText: errorText,
            ),
          ),
        ),
      ],
    );
  }

  Widget priceLayout() {
    String errorText = (valPrice == null || price.isEmpty || valPrice)
        ? null
        : AppLocalizations.of(context).coursePriceError;

    return Column(
      children: [
        CheckboxListTile(
          value: isFree,
          controlAffinity: ListTileControlAffinity.leading,
          // contentPadding: EdgeInsets.zero,
          onChanged: (state) => setState(() {
            isFree = state;
          }),
          title: _text(
            text: "Free",
            fontSize: 15.0,
          ),
        ),
        spacer(height: 10),
        Visibility(
          visible: !isFree,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _text(
                      text: AppLocalizations.of(context).coursePrice,
                      fontSize: 15.0,
                    ),
                    spacer(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Palette.lightGreyColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        onChanged: (newText) {
                          price = newText;
                          setState(() {
                            valPrice = Validator.validateText(newText);
                          });
                        },
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        style: Styles.customTextStyle(
                            color: Colors.black, fontSize: 18.0),
                        autocorrect: false,
                        cursorColor: Palette.appThemeDarkColor,
                        controller: priceCntrl,
                        textInputAction: TextInputAction.next,
                        focusNode: priceFN,
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(discFN);
                        },
                        decoration: Styles.customTextInputDecoration(
                          borderColor: Colors.transparent,
                          errorText: errorText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              spacer(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _text(
                      text: AppLocalizations.of(context).discountedPrice,
                      fontSize: 15.0,
                    ),
                    spacer(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Palette.lightGreyColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextField(
                        onChanged: (newText) {
                          discountedPrice = newText;
                        },
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.number,
                        style: Styles.customTextStyle(
                            color: Colors.black, fontSize: 18.0),
                        autocorrect: false,
                        cursorColor: Palette.appThemeDarkColor,
                        controller: discCntrl,
                        textInputAction: TextInputAction.next,
                        focusNode: discFN,
                        onSubmitted: (_) {
                          hideKeyboard(context);
                        },
                        decoration: Styles.customTextInputDecoration(
                          borderColor: Colors.transparent,
                          errorText: errorText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nextButton() {
    return CustomButton(
      borderRadius: 30,
      textColor: Colors.white,
      text: AppLocalizations.of(context).next,
      fontWeight: FontWeight.w600,
      textSize: 18.0,
      onTap: nextClicked,
    );
  }

  void nextClicked() {
    if (category == null || category == "Category") {
      showToast("Please select category");
      return;
    }
    if (subCategory == null || subCategory == "Sub Category") {
      showToast("Please select sub category");
      return;
    }
    if (childCategory == null || childCategory == "Sub Child Category") {
      showToast("Please select sub child category");
      return;
    }

    var languageId = "1"; // defaults to english
    var categoryId = "";
    var subCategoryId = "";
    var topicId = "";

    categoryList.forEach((element) {
      if (element.category == category) {
        categoryId = element.id;
      }
    });

    subCategoryList.forEach((element) {
      if (element.subcategory == subCategory) {
        subCategoryId = element.id;
      }
    });

    subChildList.forEach((element) {
      if (element.topic == childCategory) {
        topicId = element.id;
      }
    });

    languagesList.forEach((element) {
      if (element.title == language) {
        languageId = element.id;
      }
    });

    if (!Validator.validateText(title)) {
      showToast("Please enter course title");
      return;
    }
    if (!Validator.validateText(short)) {
      showToast("Please enter course sub title");
      return;
    }
    if (!Validator.validateText(requirement)) {
      showToast("Please enter course requirement");
      return;
    }
    if (!Validator.validateText(long)) {
      showToast("Please enter course description");
      return;
    }
    if (!Validator.validateText(includes)) {
      showToast("Please enter what course includes");
      return;
    }

    if (!Validator.validateText(learn)) {
      showToast("Please enter what students will learn");
      return;
    }

    if (!isFree) {
      if (!Validator.validateText(price)) {
        showToast("Please enter course price");
        return;
      }
    } else {
      price = "0";
      discountedPrice = "0";
    }

    CourseModel courseModel = CourseModel(
      title: title,
      short: short,
      long: long,
      category: categoryId,
      subCategory: subCategoryId,
      childCategory: topicId,
      language: languageId,
      price: price,
      discountPrice: discountedPrice,
      learn: learn,
      requirement: requirement,
      includes: includes,
    );

    hideKeyboard(context);

    Navigator.of(context).pushNamed(Routes.ADD_COURSE_IMAGE, arguments: {
      AppRouteArgKeys.COURSE_MODEL: courseModel,
      AppRouteArgKeys.COURSE_DATA_MODEL: _courseData
    });
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
      setState(() {});
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG_CATEGORIES);
    }
  }

  void populateSubCategories(String categoryId) async {
    SubCategoriesModel response = await ApiData.getSubCategories(categoryId);
    subCategoryList.clear();
    subCategoryNameList.clear();
    subCategoryNameList.add('Sub Category');
    if (response != null && response.subcategory != null) {
      subCategoryList.addAll(response.subcategory);
      for (int i = 0; i < subCategoryList.length; i++) {
        subCategoryNameList.add(subCategoryList[i].subcategory);
      }
      setState(() {});
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG_CATEGORIES);
    }
  }

  void populateChildCategories(String subCategoryId) async {
    TopicsModel response = await ApiData.getTopics(subCategoryId);
    subChildList.clear();
    topicsNameList.clear();
    topicsNameList.add('Select Child Category');
    if (response != null && response.topics != null) {
      subChildList.addAll(response.topics);
      for (int i = 0; i < subChildList.length; i++) {
        topicsNameList.add(subChildList[i].topic);
      }
      setState(() {});
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG_CATEGORIES);
    }
  }

  void populateLanguages() async {
    var response = await ApiData.getLanguages();
    languagesList.clear();
    languageNamesList.clear();
    if (response != null && response.languages != null) {
      languagesList.addAll(response.languages);
      for (int i = 0; i < languagesList.length; i++) {
        languageNamesList.add(languagesList[i].title);
      }

      setState(() {});
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG_CATEGORIES);
    }
  }
}
