import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/apis/api_data.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/base_scaffold.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/custom_button_widget.dart';
import 'package:my3skill_teacher_ios/base/commonwidgets/modal_progress_indicator.dart';
import 'package:my3skill_teacher_ios/base/constants.dart';
import 'package:my3skill_teacher_ios/base/global.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';
import 'package:my3skill_teacher_ios/support/ticket_status_m.dart';

class CheckTicketScreen extends StatefulWidget {
  @override
  _CheckTicketScreenState createState() => _CheckTicketScreenState();
}

class _CheckTicketScreenState extends State<CheckTicketScreen> {
  bool isBusy = false;

  String ticket;
  TextEditingController _ticketCntrl = TextEditingController();

  FocusNode _ticketFN = FocusNode();

  TicketStatusM _data;

  setBusy(value) {
    setState(() {
      isBusy = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: BaseScaffold(
        title: "Check Status",
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            accentColor: Palette.appThemeColor,
            primaryColor: Palette.appThemeColor,
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              spacer(height: 20),
              ticketTextField(),
              spacer(height: 30),
              sendButton(),
              detailsLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget ticketTextField() {
    return TextField(
      textAlign: TextAlign.start,
      keyboardType: TextInputType.text,
      style: Styles.customTextStyle(color: Colors.black, fontSize: 16.0, fontFamily: semiBold),
      autocorrect: false,
      autofocus: false,
      cursorColor: Palette.appThemeColor,
      controller: _ticketCntrl,
      textInputAction: TextInputAction.next,
      focusNode: _ticketFN,
      onSubmitted: (_) {
        hideKeyboard(context);
      },
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
        labelText: "Ticket Number",
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(),
        ),
        //fillColor: Colors.green
      ),
    );
  }

  Widget sendButton() {
    return CustomButton(
      borderRadius: 5,
      textColor: Colors.white,
      fontWeight: FontWeight.w600,
      text: "Check Ticket Status",
      textSize: 18.0,
      verticalPadding: 18,
      onTap: () {
        checkStatus();
      },
    );
  }

  Widget detailsLayout() {
    return Visibility(
      visible: _data != null,
      child: Builder(
        builder: (_) {
          return _data != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spacer(height: 50),
                    itemDetails("Ticket Number", _data.detail.ticketNo),
                    itemDetails("Name", _data.detail.name.sCap()),
                    itemDetails("Email", _data.detail.email),
                    itemDetails("Mobile Number", _data.detail.mobile),
                    itemDetails("Ticket Status", _data.detail.status == "y" ? "Open" : "Close"),
                    spacer(height: 30),
                    Text(
                      "Messages",
                      style: Styles.customTextStyle(
                        fontFamily: bold,
                        fontSize: 20,
                      ),
                    ),
                    ListView.separated(
                      itemCount: _data.messages.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, __) {
                        return Divider(height: 30, thickness: 1);
                      },
                      itemBuilder: (_, index) {
                        var message = _data.messages[0];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.message,
                              style: Styles.customTextStyle(fontSize: 17, fontFamily: medium),
                            ),
                            spacer(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                message.added,
                                style: Styles.customTextStyle(
                                  fontSize: 13,
                                  color: Palette.greyColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                )
              : SizedBox();
        },
      ),
    );
  }

  Widget itemDetails(String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Text(
                label,
                textAlign: TextAlign.start,
                style: Styles.customTextStyle(
                  fontSize: 18,
                  fontFamily: regular,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: Styles.customTextStyle(
                  fontSize: 18,
                  fontFamily: semiBold,
                ),
              ),
            ),
          ],
        ),
        Divider(color: Palette.greyColor, height: 40),
      ],
    );
  }

  checkStatus() async {
    var ticket = _ticketCntrl.text;

    if (ticket.isEmptyORNull) {
      showToast("Ticket number is required");
      return;
    }

    hideKeyboard(context);

    setBusy(true);

    Map map = {"ticket": ticket};

    var response = await ApiData.checkTicketStatus(map);

    setBusy(false);

    if (response != null && response.status == "true") {
      showToast("Ticket data loaded successfully!");
      _data = response;
    } else {
      _data = null;
      showToast(response != null ? response.message : Constants.SOMETHING_WENT_WRONG);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _ticketCntrl.dispose();
  }
}
