import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class QuantitySelector extends StatelessWidget {
  final int index;
  final int initialValue;

  const QuantitySelector(
      {Key? key, required this.index, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Rubric>(
      builder: (context, rubric, child) => AlertDialog(
        content: SpinBox(
          min: 0,
          max: 100,
          step: 1,
          value: initialValue.toDouble(),
          onChanged: (value) {
            rubric.updateGradeWeight(index, value.toInt());
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
      ),
    );
  }
}
