import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class CategoriesSelector extends StatelessWidget {
  const CategoriesSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Selector<Rubric, int>(
        builder: (context, length, child) => SingleChildScrollView(
          child: ListBody(
            children: [
              ...List.generate(
                length,
                (index) => Selector<Rubric, Factor>(
                  builder: (context, factor, child) => Column(
                    children: [
                      SizedBox(
                        child: TextField(
                          onSubmitted: (value) {
                            context.read<Rubric>().updateCategory(
                                  factor.label,
                                  Factor(value, factor.weight),
                                );
                          },
                          textInputAction: TextInputAction.go,
                          controller: TextEditingController(text: factor.label),
                        ),
                      ),
                      SpinBox(
                          min: 0,
                          max: 1000,
                          step: 1,
                          spacing: 0,
                          direction: Axis.horizontal,
                          decoration: InputDecoration(),
                          value: factor.weight,
                          onChanged: (value) {
                            context.read<Rubric>().updateCategory(
                                factor.label, Factor(factor.label, value));
                          })
                    ],
                  ),
                  selector: (context, rubric) => rubric.categories[index],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Selector<Rubric, double>(
                  builder: (context, total, child) => Text(
                    "Total: $total",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  selector: (context, rubric) => rubric.categories
                      .map((c) => c.weight)
                      .reduce((value, element) => value + element),
                ),
              )
            ],
          ),
        ),
        selector: (context, rubric) => rubric.categories.length,
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
