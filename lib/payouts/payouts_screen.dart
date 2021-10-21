import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/text_widget.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/payouts/payout_m.dart';

class PayoutScreen extends StatefulWidget {
  final StreamController<String> upwardsCom;
  final String type;

  const PayoutScreen({Key key, this.upwardsCom, this.type}) : super(key: key);

  @override
  _PayoutScreenState createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<Payment> paymentsList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMyStudents();
    showLog("Constants.userId ======>> ${Constants.userId}");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return BaseScaffold(
      child: studentsListLayout(),
      title: "${widget.type.sCap()} Payouts",
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
              : paymentsList != null && paymentsList.isNotEmpty
                  ? ListView.builder(
                      itemCount: paymentsList.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return _singleCourseItem(paymentsList[index]);
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

  Widget _singleCourseItem(Payment payment) {
    return Card(
      margin: const EdgeInsets.all(15),
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Texts(
                    payment.course.sCap(),
                    color: Palette.blackColor,
                    fontSize: 18,
                    fontFamily: semiBold,
                  ),
                ),
                Texts(
                  payment.date + " " + payment.time,
                  color: Palette.greyColor,
                  fontSize: 13,
                ),
              ],
            ),
            spacer(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Course Amount : ",
                            style: Styles.customTextStyle(
                              fontFamily: semiBold,
                              fontSize: 15,
                            )),
                        TextSpan(
                            text: payment.amount + "\n",
                            style: Styles.customTextStyle(
                              fontFamily: semiBold,
                              fontSize: 16,
                            )),
                        TextSpan(
                            text: "Commission : ",
                            style: Styles.customTextStyle(
                              fontFamily: semiBold,
                              color: Colors.red,
                              fontSize: 15,
                            )),
                        TextSpan(
                            text: payment.adminIncome.toString(),
                            style: Styles.customTextStyle(
                              fontFamily: semiBold,
                              color: Colors.red,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ),
                  spacer(height: 8),
                  Divider(height: 1, thickness: 1),
                  spacer(height: 5),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Teacher Earnings : ",
                          style: Styles.customTextStyle(
                            fontFamily: semiBold,
                            color: Colors.green,
                            fontSize: 15,
                          )),
                      TextSpan(
                          text: payment.adminIncome.toString(),
                          style: Styles.customTextStyle(
                            fontFamily: semiBold,
                            color: Colors.green,
                            fontSize: 16,
                          )),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMyStudents() async {
    setState(() {
      isLoading = true;
    });

    String userId = Constants.userId;
    if (userId == null || userId == '') return;
    PayoutM response = await ApiData.getPayoutsTypes(widget.type);

    if (response != null && response.status == 'true') {
      if (response.payment != null && response.payment.isNotEmpty) {
        paymentsList = response.payment;
      }
    } else {
      showToast(Constants.SOMETHING_WENT_WRONG);
    }

    setState(() {
      isLoading = false;
    });
  }
}
