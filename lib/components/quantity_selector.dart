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
      content: Selector<Rubric, int>(
        builder: (context, length, child) => spinBoxContainer(
          List.generate(
            length,
            (index) => Expanded(
              child: Selector<Rubric, Factor>(
                builder: (context, factor, child) => SpinBox(
                    min: 0,
                    max: max,
                    step: 1,
                    spacing: 0,
                    direction: type == QuantitySelectorType.grades
                        ? Axis.vertical
                        : Axis.horizontal,
                    decoration: InputDecoration(labelText: factor.label),
                    value: factor.weight,
                    onChanged: (value) {
                      switch (type) {
                        case QuantitySelectorType.grades:
                          context.read<Rubric>().updateGrade(
                              factor.label, Factor(factor.label, value));
                          break;
                        case QuantitySelectorType.categories:
                          context.read<Rubric>().updateCategory(
                              factor.label, Factor(factor.label, value));
                          break;
                      }
                    }),
                selector: (context, rubric) =>
                    (type == QuantitySelectorType.grades
                        ? rubric.grades[index]
                        : rubric.categories[index]),
              ),
            ),
          ),
        ),
        selector: (context, rubric) => type == QuantitySelectorType.grades
            ? rubric.grades.length
            : rubric.categories.length,
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
