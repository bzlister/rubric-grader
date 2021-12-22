import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final List<Factor> factors;
  final QuantitySelectorType type;

  const QuantitySelector({Key? key, required this.factors, required this.type})
      : super(key: key);

  Widget spinBoxContainer(List<Widget> children) {
    return type == QuantitySelectorType.grades
        ? Row(children: children)
        : Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Rubric>(
      builder: (context, rubric, child) => AlertDialog(
        content: spinBoxContainer(factors
            .map((f) => Expanded(
                    child: SpinBox(
                  min: 0,
                  max: 100,
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
                )))
            .toList()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

enum QuantitySelectorType {
  grades,
  categories,
}
