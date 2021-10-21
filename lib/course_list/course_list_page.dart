import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/common_image_layout.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/text_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/my_utils.dart';
import 'package:my3skill_teacher_ios/base/routes.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/course_list/course_list_model.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:my3skill_teacher_ios/support/payment_screen.dart';
import 'package:provider/provider.dart';

class HomeScreenPage extends StatefulWidget {
  final StreamController<String> upwardsCom;

  const HomeScreenPage({Key key, this.upwardsCom}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<CourseData> course = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCoursesApi();
    showLog("Constants.userId ======>> ${Constants.userId}");
  }

  bool isBusy = false;

  setBusy(value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        child: _courseListLayout(),
        title: AppLocalizations.of(context).courseList,
        produceWaveTitle: true,
        isDrawerVisible: true,
        onPremium: () {
          Navigator.of(context).pop();
          showPremiumDialog();
        },
        showLanguage: widget.upwardsCom != null,
        upwards: widget.upwardsCom,
        singleActionIcon: IconButton(
          icon: Icon(
            Icons.notifications,
            size: 24,
            color: Colors.white,
          ),
          onPressed: null,
        ),
      ),
    );
  }

  Widget _courseListLayout() {
    return Container(
      height: screenHeight,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Palette.appThemeColor),
                        ),
                      )
                    : course != null && course.isNotEmpty
                        ? ListView.builder(
                            itemCount: course.length,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 15.0),
                            itemBuilder: (context, index) {
                              return _singleCourseItem(course[index]);
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
          ),
          Positioned(
            bottom: 15.0,
            right: 15.0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Palette.appThemeColor,
                    Palette.appThemeLightColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: FloatingActionButton(
                onPressed: () {
                  print("Add course..");
                  Navigator.of(context).pushNamed(Routes.ADD_COURSE);
                },
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleCourseItem(CourseData courseData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _itemData(courseData),
        SizedBox(height: 10.0),
        Divider(height: 1, thickness: 1),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _itemData(CourseData courseData) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.SECTIONS_PAGE, arguments: {
          AppRouteArgKeys.COURSE_ID: courseData.id,
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CommonImageLayout(
            image: courseData.image,
            width: screenWidth * 0.3,
            height: screenHeight * 0.10,
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Text(
                        courseData.course.sCap() ?? '',
                        style: Styles.customTextStyle(
                          fontSize: 17.0,
                          color: Palette.blackColor,
                          fontFamily: semiBold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        courseData.short.sCap() ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.customTextStyle(
                          fontSize: 14.0,
                          color: Palette.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                        icon: Icon(Icons.edit_outlined),
                        onPressed: () => _editCourse(courseData),
                        padding: EdgeInsets.zero,
                        splashRadius: 25),
                    IconButton(
                        icon: Icon(Icons.delete_outline_rounded),
                        onPressed: () => _deleteCourse(courseData),
                        padding: EdgeInsets.zero,
                        splashRadius: 25),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getCoursesApi() async {
    setState(() {
      isLoading = true;
    });

    String userId = Constants.userId;
    if (userId == null || userId == '') return;
    GetCoursesModel response = await ApiData.getCoursesList(userId);

    if (response != null && response.status == 'true') {
      if (response.course != null && response.course.isNotEmpty) {
        course = response.course;
      }
    } else {
      showToast("Something went wrong.");
    }

    setState(() {
      isLoading = false;
    });
  }

  showPremiumDialog() async {
    setBusy(true);

    var response = await ApiData.getConfiguration();

    setBusy(false);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: AlertDialog(
            title: Text(
              "Features Of Premium Teacher",
              style: Styles.customTextStyle(
                fontSize: 20,
                fontFamily: bold,
                color: Palette.yellowColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    response.premiumTeacherFeature,
                    style: Styles.customTextStyle(
                      color: Palette.blackColor,
                      fontFamily: medium,
                      fontSize: 16,
                    ),
                  ),
                  spacer(height: 20),
                  Text(
                    "To become premium teacher you have to pay ${Utils.getCurrencySymbol(response.currency)}${response.premiumTeacherAmount}.",
                    style: Styles.customTextStyle(
                      color: Palette.blackColor,
                      fontFamily: medium,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
//                  color: Palette.appThemeLightColor,
//                  padding: const EdgeInsets.symmetric(horizontal: 20),
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Cancel',
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontFamily: semiBold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss alert dialog
                },
              ),
              FlatButton(
//                  color: Palette.appThemeLightColor,
//                  padding: const EdgeInsets.symmetric(horizontal: 20),
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                child: Text(
                  'Proceed To Pay',
                  style: Styles.customTextStyle(
                    color: Palette.appThemeColor,
                    fontFamily: semiBold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showPaymentProvider();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  showPaymentProvider() async {
    int selectedPayProvider;

    var response = await ApiData.getConfiguration();

    if (response != null && response.payment != null) {
      // razorPayKey = response.payment.razorKeyId;
      // premiumAmount = response.premiumAmount;
      await showDialog(
        context: context,
        barrierDismissible: false,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(builder: (_, innerState) {
            return AlertDialog(
              title: Text(
                "Select Payment Provider",
                style: Styles.customTextStyle(
                  fontSize: 20,
                  fontFamily: bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // This goes to the build method
                  Visibility(
                    visible: response.payment.stripeStatus == "y",
                    child: RadioListTile(
                      value: 1,
                      groupValue: selectedPayProvider,
                      title: Texts(
                        "Stripe",
                        color: Palette.blackColor,
                        fontFamily: bold,
                      ),
                      onChanged: (val) {
                        innerState(() {
                          selectedPayProvider = val;
                        });
                      },
                      activeColor: Palette.appThemeColor,
                      selected: true,
                    ),
                  ),
                  /*Visibility(
                    visible: response.payment.razorStatus == "y",
                    child: RadioListTile(
                      value: 2,
                      groupValue: selectedPayProvider,
                      title: Texts(
                        "Razorpay",
                        color: Palette.blackColor,
                        fontFamily: bold,
                      ),
                      onChanged: (val) {
                        innerState(() {
                          selectedPayProvider = val;
                        });
                      },
                      activeColor: Palette.appThemeColor,
                      selected: false,
                    ),
                  ),*/
                  Visibility(
                    visible: response.payment.razorStatus == "n" &&
                        response.payment.stripeStatus == "n",
                    child: Texts(
                      "No payment method selected by Admin.",
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: Styles.customTextStyle(
                      color: Palette.appThemeColor,
                      fontFamily: bold,
                    ),
                  ),
                  onPressed: () {
                    selectedPayProvider = null;
                    Navigator.of(context).pop();
                  },
                ),
                Visibility(
                  visible: response.payment.razorStatus == "y" ||
                      response.payment.stripeStatus == "y",
                  child: FlatButton(
                    child: Text(
                      'Pay Now',
                      style: Styles.customTextStyle(
                        color: Palette.appThemeColor,
                        fontFamily: bold,
                      ),
                    ),
                    onPressed: () {
                      if (selectedPayProvider != null) {
                        Navigator.of(context).pop();
                      } else {
                        showToast(
                            "Please select payment provider to continue!");
                      }
                    },
                  ),
                ),
              ],
            );
          });
        },
      );

      showLog("selectedPayProvider ====> $selectedPayProvider");

      if (selectedPayProvider != null) {
        if (selectedPayProvider == 1) {
          payUsingStripe();
        } else {
          payUsingRazorPay();
        }
      }
    }
  }

  void payUsingRazorPay() async {
    // var options = {
    //   'key': razorPayKey,
    //   'amount': premiumAmount.toInt() * 100,
    //   'name': _user.name,
    //   'description': 'Add money to wallet!',
    //   'prefill': {'contact': _user.mobile, 'email': _user.email},
    // };

    // try {
    //   _razorpay.open(options);
    // } catch (e) {
    //   debugPrint(e);
    // }
  }

  payUsingStripe() async {
    await Future.delayed(Duration(milliseconds: 200));

    var isPremium = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          premium: "true",
        ),
      ),
    );

    if (isPremium != null && isPremium.toString() == "Payment Success") {
      showSuccessDialog();
    }
  }

  showSuccessDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            "Congratulations",
            style: Styles.customTextStyle(
              fontSize: 20,
              fontFamily: bold,
            ),
          ),
          content: Text(
            "You are now premium member with us you can now enjoy premium features of My3Skills Teacher.\n\nThank you for choosing us.",
            style: Styles.customTextStyle(
              color: Palette.greyColor,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok Thank you!',
                style: Styles.customTextStyle(
                    color: Palette.appThemeColor, fontFamily: semiBold),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );

    setBusy(true);
    await Provider.of<AuthProvider>(context, listen: false).getUserProfile();
    setBusy(false);
  }

  void _editCourse(CourseData courseData) {
    Navigator.of(context).pushNamed(Routes.ADD_COURSE,
        arguments: {AppRouteArgKeys.COURSE_DATA_MODEL: courseData});
  }

  void _deleteCourse(CourseData courseData) async {
    setBusy(true);
    var data = await ApiData.deleteCourse(courseData.id);
    setBusy(false);
    if (data != null && data.status == 'true') {
      setState(() {
        course.remove(courseData);
      });
    } else {
      showToast('Unable to delete course');
    }
  }
}
