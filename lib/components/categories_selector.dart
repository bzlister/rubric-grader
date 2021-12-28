import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class CategoriesSelector extends StatefulWidget {
  final int index;
  final Factor category;

  const CategoriesSelector.update(
      {Key? key, required this.index, required this.category})
      : super(key: key);

  CategoriesSelector.add({Key? key})
      : index = -1,
        category = Factor("", 0),
        super(key: key);

  @override
  _CategoriesSelectorState createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends State<CategoriesSelector> {
  late Factor _category;

  @override
  void initState() {
    super.initState();
    _category = Factor(widget.category.label, widget.category.weight);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Wrap(
          children: [
            SizedBox(
              child: TextField(
                onSubmitted: (value) {
                  setState(() {
                    _category.label = value;
                  });
                },
                textInputAction: TextInputAction.go,
                controller: TextEditingController(text: _category.label),
              ),
            ),
            SpinBox(
                min: 0,
                max: 1000,
                step: 1,
                spacing: 0,
                direction: Axis.horizontal,
                value: _category.weight,
                onChanged: (value) {
                  setState(() {
                    _category.weight = value;
                  });
                })
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.index != -1) {
                context.read<Rubric>().updateCategory(widget.index, _category);
              } else {
                context.read<Rubric>().addCategory(_category);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ]);
  }
}
