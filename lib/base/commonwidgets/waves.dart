import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: WaveScreen());
  }
}

class WaveScreen extends StatefulWidget {
  @override
  _WaveScreenState createState() => _WaveScreenState();
}

class _WaveScreenState extends State<WaveScreen> {
  var _slider = 0.0;
  var _depth = 10.0;
  var _red = 0.0;
  var _green = 0.0;
  var _blue = 0.0;

  var _orientation = 0;
  var _waveOrientation = Orientation.UP;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment(0, 0),
          child: FittedBox(
            fit: BoxFit.none,
            child: Column(
              children: [
                SizedBox(height: 40),
                Text('Orientation'),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _orientation,
                        onChanged: _orientationChanged,
                      ),
                      Text('UP'),
                      Radio(
                        value: 1,
                        groupValue: _orientation,
                        onChanged: _orientationChanged,
                      ),
                      Text('UP REVERSE'),
                      Radio(
                        value: 2,
                        groupValue: _orientation,
                        onChanged: _orientationChanged,
                      ),
                      Text('DOWN'),
                      Radio(
                        value: 3,
                        groupValue: _orientation,
                        onChanged: _orientationChanged,
                      ),
                      Text('DOWN REVERSE'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Color Selector'),
                Container(
                  width: size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Slider(
                        value: _red,
                        onChanged: (value) => setState(() => _red = value),
                        min: 0,
                        max: 255,
                        divisions: 255,
                        activeColor: Colors.red,
                        inactiveColor: Colors.red,
                      ),
                      Slider(
                        value: _green,
                        onChanged: (value) => setState(() => _green = value),
                        min: 0,
                        max: 255,
                        divisions: 255,
                        activeColor: Colors.green,
                        inactiveColor: Colors.green,
                      ),
                      Slider(
                        value: _blue,
                        onChanged: (value) => setState(() => _blue = value),
                        min: 0,
                        max: 255,
                        divisions: 255,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text('Waves: ${_slider.toInt()}'),
                Container(
                  width: size.width - 60,
                  child: Slider(
                    value: _slider,
                    onChanged: (value) => setState(() => _slider = value),
                    min: 0,
                    max: 80,
                    divisions: 80,
                    activeColor: Color.fromARGB(255, _red.toInt(), _green.toInt(), _blue.toInt()),
                    inactiveColor: Color.fromARGB(255, _red.toInt(), _green.toInt(), _blue.toInt()),
                  ),
                ),
                Text('Depth: ${_depth.toInt()}'),
                Container(
                  width: size.width - 60,
                  child: Slider(
                    value: _depth,
                    onChanged: (value) => setState(() => _depth = value),
                    min: 0,
                    max: 80,
                    activeColor: Color.fromARGB(255, _red.toInt(), _green.toInt(), _blue.toInt()),
                    inactiveColor: Color.fromARGB(255, _red.toInt(), _green.toInt(), _blue.toInt()),
                  ),
                ),
                SizedBox(height: 10),
                ClipPath(
                  clipper: _slider.toInt() == 0
                      ? null
                      : WaveGeneratorPath(
                          amount: _slider.toInt(),
                          depth: _depth.toInt(),
                          orientation: _waveOrientation),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    width: size.width,
                    height: 200,
                    color: Color.fromARGB(255, _red.toInt(), _green.toInt(), _blue.toInt()),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _orientationChanged(int index) {
    setState(() => _orientation = index);
    switch (index) {
      case 0:
        setState(() => _waveOrientation = Orientation.UP);
        break;
      case 1:
        setState(() => _waveOrientation = Orientation.UP_REVERSE);
        break;
      case 2:
        setState(() => _waveOrientation = Orientation.DOWN);
        break;
      case 3:
        setState(() => _waveOrientation = Orientation.DOWN_REVERSE);
        break;
    }
  }
}

enum Orientation { UP, UP_REVERSE, DOWN, DOWN_REVERSE }

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
            Orientation.UP: 0.0 + depth,
            Orientation.UP_REVERSE: 0.0 + depth,
            Orientation.DOWN: size.height - depth,
            Orientation.DOWN_REVERSE: size.height - depth,
          }));
      path.quadraticBezierTo(
          (sections * index) + (sections / 2),
          when(orientation, {
            Orientation.UP: index % 2 == 0 ? 0.0 + depth * 3 : 0.0 - depth,
            Orientation.UP_REVERSE: index % 2 != 0 ? 0.0 + depth * 3 : 0.0 - depth,
            Orientation.DOWN: index % 2 == 0 ? size.height + depth : size.height - (depth * 3),
            Orientation.DOWN_REVERSE:
                index % 2 != 0 ? size.height + depth : size.height - (depth * 3),
          }),
          sections * (index + 1),
          when(orientation, {
            Orientation.UP: 0.0 + depth,
            Orientation.UP_REVERSE: 0.0 + depth,
            Orientation.DOWN: size.height - depth,
            Orientation.DOWN_REVERSE: size.height - depth,
          }));
    }
    path.lineTo(size.width, 0.0);
    if (orientation == Orientation.UP || orientation == Orientation.UP_REVERSE) {
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
