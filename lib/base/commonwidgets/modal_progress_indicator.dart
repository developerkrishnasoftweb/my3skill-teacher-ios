import 'package:flutter/material.dart';
import 'package:my3skill_teacher_ios/base/theme/palette.dart';

class ModalProgressHUD extends StatelessWidget {
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Offset offset;
  final bool dismissible;
  final Widget child;
  final Color valueColor;
  final bool isAnimated;

  ModalProgressHUD({
    Key key,
    @required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.offset,
    this.dismissible = false,
    @required this.child,
    this.isAnimated: false,
    this.valueColor: Palette.appThemeColor,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!inAsyncCall) return child;

    Widget layOutProgressIndicator;
    if (offset == null) {
      layOutProgressIndicator = Center(
        child: Container(
          alignment: Alignment.center,
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(valueColor),
              ),
            ],
          ),
        ),
      );
    } else {
      layOutProgressIndicator = Positioned(
        child: Container(
          alignment: Alignment.center,
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          color: Colors.transparent,
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(valueColor),
          ),
        ),
        left: offset.dx,
        top: offset.dy,
      );
    }

    return new Stack(
      children: [
        child,
        Positioned.fill(
          child: Opacity(
            child: ModalBarrier(dismissible: dismissible, color: color),
            opacity: opacity,
          ),
        ),
        layOutProgressIndicator,
      ],
    );
  }
}
