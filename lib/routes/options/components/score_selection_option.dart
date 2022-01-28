import 'package:flutter/material.dart';

class ScoreSelectionOption extends StatefulWidget {
  const ScoreSelectionOption({Key? key}) : super(key: key);

  @override
  _ScoreSelectionOptionState createState() => _ScoreSelectionOptionState();
}

class _ScoreSelectionOptionState extends State<ScoreSelectionOption> {
  late bool _useSliders;

  @override
  void initState() {
    super.initState();
    _useSliders = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Score selection"),
        ),
        const Spacer(),
        SizedBox(
          width: 100,
          child: Switch(
            value: _useSliders,
            onChanged: (x) {
              setState(() {
                _useSliders = x;
              });
            },
          ),
        ),
      ],
    );
  }
}
