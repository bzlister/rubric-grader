import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class GradesSelector extends StatelessWidget {
  const GradesSelector({Key? key}) : super(key: key);

  double getMin(int index, List<Factor> grades) {
    if (index < grades.length - 1) {
      return grades[index + 1].weight + 1;
    }
    return 0;
  }

  double getMax(int index, List<Factor> grades) {
    if (index > 0) {
      return grades[index - 1].weight - 1;
    }
    return 100;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Selector<Rubric, List<Factor>>(
        builder: (context, grades, child) => Row(
          children: List.generate(
            grades.length,
            (index) {
              double min = getMin(index, grades);
              double max = getMax(index, grades);
              Factor grade = grades[index];
              return Expanded(
                child: SpinBox(
                    min: min,
                    max: max,
                    step: 1,
                    spacing: 0,
                    direction: Axis.vertical,
                    decoration: InputDecoration(
                      label: Text(grade.label),
                      focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                    ),
                    value: grade.weight,
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
                        context
                            .read<Rubric>()
                            .updateGrade(index, grade.label, value);
                      }
                    }),
              );
            },
          ),
        ),
        selector: (context, rubric) => rubric.grades,
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
