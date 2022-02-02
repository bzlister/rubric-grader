import 'dart:collection';
import 'dart:math';
import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';

class GradedAssignment extends ChangeNotifier {
  final HashMap<Category, SemanticValue> _scoreSelections;
  int daysLate;
  late Rubric _rubric;
  String? comment;
  String? name;

  GradedAssignment(
    this._scoreSelections,
    this.daysLate,
    this.comment,
    this.name,
  );

  GradedAssignment.empty()
      : _scoreSelections = HashMap<Category, SemanticValue>(),
        daysLate = 0;

  set rubric(Rubric newRubric) {
    _rubric = newRubric;
  }

  double get earnedPoints {
    double points = 0;
    for (MapEntry<Category, SemanticValue> entry in _scoreSelections.entries) {
      points += entry.key.weight * entry.value.weight * 0.01;
    }
    return points;
  }

  select(Category category, SemanticValue semanticValue) {
    _scoreSelections[category] = semanticValue;
  }

  double get latePenalty {
    double percentageOff = daysLate * _rubric.latePercentagePerDay * 0.01;
    return min(
      percentageOff *
          (_rubric.latePolicy == "total" ? _rubric.totalPoints : earnedPoints),
      earnedPoints,
    );
  }

  Tuple2<String, double> calcGrade(GradingScale gradingScale) {
    double total = _rubric.totalPoints;
    if (total == 0) {
      return const Tuple2("", 0);
    }
    double finalScore = (earnedPoints - latePenalty) / total * 100;
    String label = gradingScale.scale[0].item1;
    for (int i = 0; i < gradingScale.scale.length; i++) {
      if (gradingScale.scale[i].item2 <= finalScore) {
        label = gradingScale.scale[i].item1;
        break;
      }
    }
    return Tuple2(label, finalScore);
  }
}
