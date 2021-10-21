import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/text_widget.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/mixins/after_build.dart';
import 'package:my3skill_teacher_ios/base/my_utils.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/login/login_model.dart';
import 'package:my3skill_teacher_ios/providers/auth_provider.dart';
import 'package:my3skill_teacher_ios/support/pay_config_m.dart';
import 'package:my3skill_teacher_ios/support/payment_screen.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatefulWidget {
  @override
  _PremiumScreenState createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> with AfterLayoutMixin<PremiumScreen> {
  String razorPayKey = "", premiumAmount = "";

  AuthModel _user;

  PaymentConfigM _premium;

  @override
  void initState() {
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    setBusy(true);

    await Provider.of<AuthProvider>(context, listen: false).getUserProfile();
    _user = Provider.of<AuthProvider>(context, listen: false).user;

    _premium = await ApiData.getConfiguration();

    setBusy(false);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
          title: "Premium Teacher",
          leading:
              IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
          child: _premium == null
              ? SizedBox()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: AlertDialog(
                      title: Text(
                        "Features Of Premium Teacher",
                        style: Styles.customTextStyle(fontSize: 20, fontFamily: bold, color: Palette.yellowColor),
                      ),
                      content: SingleChildScrollView(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          _premium.premiumTeacherFeature,
                          style: Styles.customTextStyle(color: Palette.blackColor, fontFamily: medium, fontSize: 16),
                        ),
                        spacer(height: 20),
                        Text(
                            "To become premium teacher you have to pay ${Utils.getCurrencySymbol(_premium.currency)}${_premium.premiumTeacherAmount}.",
                            style: Styles.customTextStyle(color: Palette.blackColor, fontFamily: medium, fontSize: 16))
                      ])),
                      actions: <Widget>[
                        FlatButton(
//                  color: Palette.appThemeLightColor,
//                  padding: const EdgeInsets.symmetric(horizontal: 20),
//                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child:
                              Text('Cancel', style: Styles.customTextStyle(color: Palette.appThemeColor, fontFamily: semiBold)),
                          onPressed: () => Navigator.of(context).pop(),
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
                            })
                      ]))),
      // : SingleChildScrollView(
      //     padding: const EdgeInsets.all(15),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           child: Text(
      //             "Features Of Premium Teacher",
      //             style: Styles.customTextStyle(
      //               fontSize: 20,
      //               fontFamily: bold,
      //               color: Palette.yellowColor,
      //             ),
      //           ),
      //         ),
      //         spacer(height: 20),
      //         Text(
      //           _premium.premiumFeature,
      //           style: Styles.customTextStyle(
      //             color: Palette.blackColor,
      //             fontFamily: medium,
      //             fontSize: 16,
      //           ),
      //         ),
      //         spacer(height: 20),
      //         Text(
      //           "To become premium teacher you have to pay ${Utils.getCurrencySymbol(_premium.currency)}${_premium.premiumTeacherAmount}.",
      //           style: Styles.customTextStyle(
      //             color: Palette.blackColor,
      //             fontFamily: medium,
      //             fontSize: 16,
      //           ),
      //         ),
      //         spacer(height: 50),
      //         Align(
      //           child: FlatButton(
      //             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      //             color: Palette.appThemeColor,
      //             child: Text(
      //               '     Proceed To Pay     ',
      //               style: Styles.customTextStyle(
      //                 color: Colors.white,
      //                 fontFamily: semiBold,
      //               ),
      //             ),
      //             onPressed: () {
      //               showPaymentProvider();
      //             },
      //           ),
      //         )
      //       ],
      //     ),
      //   ),
    );
  }

  bool isBusy = false;

  setBusy(value) {
    if (!mounted) return;
    setState(() {
      isBusy = value;
    });
  }

  showPaymentProvider() async {
    int selectedPayProvider;

    var response = await ApiData.getConfiguration();

    if (response != null && response.payment != null) {
      razorPayKey = response.payment.razorKeyId;
      premiumAmount = response.premiumAmount;
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
                    visible: response.payment.razorStatus == "n" && response.payment.stripeStatus == "n",
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
                  visible: response.payment.razorStatus == "y" || response.payment.stripeStatus == "y",
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
                        showToast("Please select payment provider to continue!");
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
    var options = {
      'key': razorPayKey,
      'amount': premiumAmount.toInt() * 100,
      'name': _user.name,
      'description': 'Add money to wallet!',
      'prefill': {'contact': _user.mobile, 'email': _user.email},
    };

    // try {
    //   _razorpay.open(options);
    // } catch (e) {
    //   debugPrint(e);
    // }
  }

  payUsingStripe() async {
//    await Utils.secureMyScreen();
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
            "You are now premium member with us you can now enjoy premium features of MySkills.\nThank you for choosing us.",
            style: Styles.customTextStyle(
              color: Palette.greyColor,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok Thank you!',
                style: Styles.customTextStyle(color: Palette.appThemeColor, fontFamily: semiBold),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );

    await Provider.of<AuthProvider>(context, listen: false).getUserProfile();
    setState(() {});
  }
}
