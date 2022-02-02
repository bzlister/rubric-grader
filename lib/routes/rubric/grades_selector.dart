import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class ScoresSelector extends StatelessWidget {
  const ScoresSelector({Key? key}) : super(key: key);

  double getMin(int index, List<double> scores) {
    if (index < scores.length - 1) {
      return scores[index + 1] + 1;
    }
    return 0;
  }

  double getMax(int index, List<double> scores) {
    if (index > 0) {
      return scores[index - 1] - 1;
    }
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Selector<Rubric, List<double>>(
        builder: (context, scores, child) => Row(
          children: List.generate(
            scores.length,
            (index) {
              double min = getMin(index, scores);
              double max = getMax(index, scores);
              double score = scores[index];
              return Expanded(
                child: SpinBox(
                    min: min,
                    max: max,
                    step: 1,
                    spacing: 0,
                    direction: Axis.vertical,
                    decoration: const InputDecoration(
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                    value: score,
                    validator: (value) {
                      try {
                        if (value != null) {
                          double weight = double.parse(value);
                          if (weight < min) {
                            return "";
                          } else if (weight > max) {
                            return "";
                          }
                        } else {
                          return "";
                        }
                      } catch (numberFormatException) {
                        return "";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value <= max && value >= min) {
                        context.read<Rubric>().updateScore(index, value);
                      }
                    }),
              );
            },
          ),
        ),
        selector: (context, rubric) =>
            rubric.scoreBins.map((s) => s.weight).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
