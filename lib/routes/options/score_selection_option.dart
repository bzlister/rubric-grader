import 'package:flapp/models/grader.dart';
import 'package:flapp/score_selection_paradigm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    _useSliders = context.read<Grader>().scoreSelectionParadigm == ScoreSelectionParadigm.slider;
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
        Selector<Grader, Color>(
          builder: (context, highlight, child) => Text("Bins", style: _useSliders ? TextStyle(color: highlight) : null),
          selector: (context, grader) => grader.themeData.highlightColor,
        ),
        SizedBox(
          width: 100,
          child: Switch(
            value: _useSliders,
            onChanged: (x) {
              setState(() {
                _useSliders = x;
                context.read<Grader>().scoreSelectionParadigm =
                    _useSliders ? ScoreSelectionParadigm.slider : ScoreSelectionParadigm.bin;
              });
            },
          ),
        ),
        Selector<Grader, Color>(
          builder: (context, highlight, child) =>
              Text("Sliders", style: _useSliders ? null : TextStyle(color: highlight)),
          selector: (context, grader) => grader.themeData.highlightColor,
        ),
      ],
    );
  }
}
