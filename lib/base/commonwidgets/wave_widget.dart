import 'package:flutter/material.dart';

enum OrientationWave { UP, UP_REVERSE, DOWN, DOWN_REVERSE }

class WaveGeneratorPath extends CustomClipper<Path> {
  final amount;
  final depth;
  final orientation;

  WaveGeneratorPath({this.amount, this.depth, this.orientation});

  @override
  Path getClip(Size size) {
    var path = new Path();
    var sections = size.width / amount;
    for (int index = 0; index < amount; index++) {
      path.lineTo(
          sections * index,
          when(orientation, {
            OrientationWave.UP: 0.0 + depth,
            OrientationWave.UP_REVERSE: 0.0 + depth,
            OrientationWave.DOWN: size.height - depth,
            OrientationWave.DOWN_REVERSE: size.height - depth,
          }));
      path.quadraticBezierTo(
          (sections * index) + (sections / 2),
          when(orientation, {
            OrientationWave.UP: index % 2 == 0 ? 0.0 + depth * 3 : 0.0 - depth,
            OrientationWave.UP_REVERSE: index % 2 != 0 ? 0.0 + depth * 3 : 0.0 - depth,
            OrientationWave.DOWN: index % 2 == 0 ? size.height + depth : size.height - (depth * 3),
            OrientationWave.DOWN_REVERSE:
                index % 2 != 0 ? size.height + depth : size.height - (depth * 3),
          }),
          sections * (index + 1),
          when(orientation, {
            OrientationWave.UP: 0.0 + depth,
            OrientationWave.UP_REVERSE: 0.0 + depth,
            OrientationWave.DOWN: size.height - depth,
            OrientationWave.DOWN_REVERSE: size.height - depth,
          }));
    }
    path.lineTo(size.width, 0.0);
    if (orientation == OrientationWave.UP || orientation == OrientationWave.UP_REVERSE) {
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

Type when<Input, Type>(Input selectedOption, Map<Input, Type> branches, [Type defaultValue]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }
  return branches[selectedOption];
}
