import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class CategoriesSelector extends StatelessWidget {
  final int index;

  const CategoriesSelector({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Selector<Rubric, Factor>(
          builder: (context, category, child) => Wrap(
            children: [
              SizedBox(
                child: TextField(
                  onSubmitted: (value) {
                    context
                        .read<Rubric>()
                        .updateCategory(index, Factor(value, category.weight));
                  },
                  textInputAction: TextInputAction.go,
                  controller: TextEditingController(text: category.label),
                ),
              ),
              SpinBox(
                  min: 0,
                  max: 1000,
                  step: 1,
                  spacing: 0,
                  direction: Axis.horizontal,
                  value: category.weight,
                  onChanged: (value) {
                    context
                        .read<Rubric>()
                        .updateCategory(index, Factor(category.label, value));
                  })
            ],
          ),
          selector: (context, rubric) => rubric.categories[index],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ]);
  }
}
