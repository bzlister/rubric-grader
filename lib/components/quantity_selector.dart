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

  const QuantitySelector.total({Key? key})
      : max = double.maxFinite,
        type = QuantitySelectorType.total,
        super(key: key);

  Widget spinBoxContainer(List<Widget> children) {
    switch (type) {
      case QuantitySelectorType.grades:
        return Row(children: children);
      case QuantitySelectorType.categories:
        return Column(children: children);
      case QuantitySelectorType.total:
        return children[0];
    }
  }

  Widget wrapper(Widget child) {
    switch (type) {
      case QuantitySelectorType.grades:
      case QuantitySelectorType.categories:
        return Expanded(child: child);
      case QuantitySelectorType.total:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Selector<Rubric, int>(
        builder: (context, length, child) => spinBoxContainer(
          List.generate(
            length,
            (index) => wrapper(
              Selector<Rubric, Factor>(
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
                          case QuantitySelectorType.total:
                            context.read<Rubric>().setTotalPoints(value);
                            break;
                        }
                      }),
                  selector: (context, rubric) {
                    switch (type) {
                      case QuantitySelectorType.grades:
                        return rubric.grades[index];
                      case QuantitySelectorType.categories:
                        return rubric.categories[index];
                      case QuantitySelectorType.total:
                        return rubric.totalPoints;
                    }
                  }),
            ),
          ),
        ),
        selector: (context, rubric) {
          switch (type) {
            case QuantitySelectorType.grades:
              return rubric.grades.length;
            case QuantitySelectorType.categories:
              return rubric.categories.length;
            case QuantitySelectorType.total:
              return 1;
          }
        },
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
  total,
}
