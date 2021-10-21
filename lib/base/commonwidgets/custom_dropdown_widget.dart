import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';
import 'package:my3skill_teacher_ios/base/theme/styles.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List<String> valuesList;
  final Function selectedValue;
  final String initialValue;
  final double bottomLeft;
  final double bottomRight;
  final double topLeft;
  final double topRight;
  final Color themeColor;
  final Color canvasColor;
  final Color themeTextColor;
  final double padding;
  final String errorText;
  final Widget arrowWidget;
  final bool validateGender;
  final double textSize;

  const CustomDropdownWidget({
    Key key,
    this.valuesList,
    this.selectedValue,
    this.initialValue,
    this.arrowWidget,
    this.validateGender,
    this.canvasColor,
    this.bottomLeft: 5.0,
    this.bottomRight: 5.0,
    this.topLeft: 5.0,
    this.topRight: 5.0,
    this.themeColor: Palette.appThemeLightColor,
    this.themeTextColor: Colors.black,
    this.padding: 0.0,
    this.errorText,
    this.textSize: 18.0,
  }) : super(key: key);

  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdownWidget oldWidget) {
//    print("The widgets updated... ${widget.valuesList.length}");
    if (widget.valuesList.length > 1 && dropdownValue == 'Cur.') {
      dropdownValue = widget.valuesList[1];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
//    print("The initial value : ${widget.initialValue}");
    if (widget.valuesList == null ||
        widget.valuesList.isEmpty ||
        !widget.valuesList.contains(dropdownValue)) {
      dropdownValue = widget.initialValue;
    }

//    if(widget.initialValue != 'Cur.' && dropdownValue!=''){
//      dropdownValue = widget.initialValue;
//    }
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: widget.canvasColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buttonThemeWidget(),
          _errorWidget(),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Visibility(
      visible:
          (widget.errorText == null || widget.errorText == '') ? false : true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              widget.errorText != null ? widget.errorText : '',
              style: Styles.customTextStyle(
                fontSize: 12.0,
                color: Palette.lightRedColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonThemeWidget() {
//    print("The dropdown value is : $dropdownValue");
    return ButtonTheme(
      alignedDropdown: true,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: widget.padding),
        decoration: BoxDecoration(
            color: widget.themeColor,
            border: Border(
              bottom: BorderSide(color: Palette.blackColor, width: 0.5),
            )),
        child: DropdownButtonHideUnderline(
          child: Listener(
            onPointerDown: (_) => FocusScope.of(context).unfocus(),
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              iconSize: 30,
              icon: widget.arrowWidget,
              iconDisabledColor: widget.themeTextColor,
              iconEnabledColor: widget.themeTextColor,
              style: TextStyle(
                color: widget.themeTextColor,
                fontSize: widget.textSize,
                fontFamily: 'Cabin-Regular',
              ),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                  widget.selectedValue(dropdownValue);
                });
              },
              items: widget.valuesList != null && widget.valuesList.isNotEmpty
                  ? widget.valuesList
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Styles.customTextStyle(
                              fontWeight: FontWeight.normal,
                              color: widget.themeTextColor,
                              fontSize: widget.textSize),
                        ),
                      );
                    }).toList()
                  : [dropdownValue]
                      .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Styles.customTextStyle(
                              fontWeight: FontWeight.normal,
                              color: widget.themeTextColor,
                              fontSize: widget.textSize),
                        ),
                      );
                    }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
