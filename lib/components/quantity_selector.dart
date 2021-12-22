import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final double max;
  final QuantitySelectorType type;

  const QuantitySelector.grades({Key? key})
      : max = 100,
        type = QuantitySelectorType.grades,
        super(key: key);

  const QuantitySelector.categories({Key? key})
      : max = double.maxFinite,
        type = QuantitySelectorType.categories,
        super(key: key);

  Widget spinBoxContainer(List<Widget> children) {
    return type == QuantitySelectorType.grades
        ? Row(children: children)
        : Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Consumer<Rubric>(
        builder: (context, rubric, child) => spinBoxContainer(
            (type == QuantitySelectorType.grades
                    ? rubric.grades
                    : rubric.categories)
                .map(
                  (f) => Expanded(
                    child: SpinBox(
                      min: 0,
                      max: max,
                      step: 1,
                      spacing: 0,
                      direction: type == QuantitySelectorType.grades
                          ? Axis.vertical
                          : Axis.horizontal,
                      decoration: InputDecoration(labelText: f.label),
                      value: f.weight,
                      onChanged: (value) {
                        rubric.updateGrade(f.label, Factor(f.label, value));
                      },
                    ),
                  ),
                )
                .toList()),
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

enum QuantitySelectorType {
  grades,
  categories,
}
