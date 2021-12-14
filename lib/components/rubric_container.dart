import 'package:flapp/components/rubric_template.dart';
import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';

final List<Factor> categories = [
  Factor("Audience & Genre", 0.3),
  Factor("Thesis & Support", 0.3),
  Factor("Reasoning", 0.2),
  Factor("Organization & Style", 0.15),
  Factor("Correctness", 0.05)
];

final List<Factor> grades = [
  Factor("A", 1.0),
  Factor("B", 0.85),
  Factor("C", 0.75),
  Factor("D", 0.7),
  Factor("F", 0.6)
];

class RubricContainer extends StatelessWidget {
  const RubricContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RubricTemplate(
      categories: categories,
      grades: grades,
      totalPoints: 200,
    );
  }
}
