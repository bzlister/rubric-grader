import 'package:flapp/components/row_button.dart';
import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';

class Rubric extends StatefulWidget {
  final List<Factor> categories;
  final List<Factor> grades;
  final int totalPoints;

  const Rubric(
      {Key? key,
      required this.categories,
      required this.grades,
      required this.totalPoints})
      : super(key: key);

  @override
  State<Rubric> createState() => _RubricState();
}

class _RubricState extends State<Rubric> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: List.generate(
        widget.categories.length,
        (index) => ToggleButtonWidget(
          index: index,
          len: widget.grades.length,
          category: widget.categories[index],
          grades: widget.grades,
          total: widget.totalPoints,
        ),
      ),
    );
  }
}
