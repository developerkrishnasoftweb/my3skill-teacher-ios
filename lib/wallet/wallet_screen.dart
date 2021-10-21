import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/images_link.dart';
import 'package:my3skill_teacher_ios/base/mixins/after_build.dart';
import 'package:my3skill_teacher_ios/base/my_utils.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/localizations.dart';
import 'package:my3skill_teacher_ios/providers/wallet_provider.dart';
import 'package:my3skill_teacher_ios/wallet/wallet_model.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with AfterLayoutMixin<WalletScreen> {
  WalletProvider _provider;

  WalletModel _wallet;

  getTeacherWallet() async {
    var response = await _provider.getTeacherWallet();
    if (response != null && response.status == "true") {
      _wallet = response;
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    showLog("afterFirstLayout");
    getTeacherWallet();
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<WalletProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _provider.loading,
      child: BaseScaffold(
        title: AppLocalizations.of(context).wallet,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        child: _wallet != null
            ? Column(
                children: [
                  _walletBalance(),
                  _transactionLayout(),
                ],
              )
            : SizedBox(),
      ),
    );
  }

  Widget _walletBalance() {
    return Container(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _text(
            AppLocalizations.of(context).walletBalance,
            fontSize: 20,
            color: Palette.greyColor.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          spacer(height: 8),
          _text(
            "${Utils.getCurrencySymbol(_wallet.currency)}${_wallet.balance.toDouble() ?? 00.00}",
            fontSize: 26,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          spacer(height: 30),
          Divider(
            height: 1,
            thickness: 5,
            color: Palette.appThemeLightColor,
          ),
        ],
      ),
    );
  }

  Widget _transactionLayout() {
    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: _wallet.transaction != null && _wallet.transaction.isNotEmpty
            ? ListView.separated(
                separatorBuilder: (_, __) {
                  return Divider(
                    thickness: 1,
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  );
                },
                itemCount: _wallet.transaction.length,
                itemBuilder: (c, index) {
                  return itemTransaction(_wallet.transaction[index]);
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context).noTransaction,
                  style: Styles.customTextStyle(fontSize: 20),
                ),
              ),
      ),
    );
  }

  Widget itemTransaction(Transaction transaction) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 110,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(height: 12),
            _text(Utils.formatDateMMM(transaction.transDate)),
            spacer(height: 8),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Palette.appThemeLightColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Image.asset(
                          transaction.type == "d" ? ImagesLink.DOWN : ImagesLink.UP,
                          color: Palette.appThemeLightColor,
                        ),
                      ),
                    ),
                    spacer(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _text(
                            transaction.type == "d"
                                ? AppLocalizations.of(context).withdrawMoney
                                : AppLocalizations.of(context).depositMoney,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          spacer(height: 10),
                          _text(
                            Utils.formatTimeHH(transaction.transDate),
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          spacer(height: 5),
                          _text(
                            "${transaction.type == "c" ? "+" : "-"}${Utils.getCurrencySymbol(_wallet.currency)}${transaction.amount}",
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          spacer(height: 10),
                          _text(
                            "${AppLocalizations.of(context).closingBalance} : ${Utils.getCurrencySymbol(_wallet.currency)}${transaction.amount}",
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _text(String text, {double fontSize, Color color, FontWeight fontWeight}) {
    return Text(
      text,
      style: Styles.customTextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
