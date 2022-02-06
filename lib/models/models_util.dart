import 'dart:math';

import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:tuple/tuple.dart';
import 'package:xid/xid.dart';

class ModelsUtil {
  static calcEarnedPoints(Rubric rubric, GradedAssignment gradedAssignment) {
    double points = 0;
    for (MapEntry<Xid, Xid> entry in gradedAssignment.selections.entries) {
      Category? category = rubric.getCategoryByXid(entry.key);
      double? score = rubric.getScoreByXid(entry.value);
      if (category != null && score != null) {
        points += category.weight * score * 0.01;
      }
    }
    return points;
  }

  static calcLatePenalty(Rubric rubric, GradedAssignment gradedAssignment) {
    double percentageOff =
        gradedAssignment.daysLate * rubric.latePercentagePerDay * 0.01;
    double earnedPoints = calcEarnedPoints(rubric, gradedAssignment);
    return min(
      percentageOff *
          (rubric.latePolicy == "total" ? rubric.totalPoints : earnedPoints),
      earnedPoints,
    );
  }

  static Tuple2<String, double> calcGrade(
    Grader grader,
    Rubric rubric,
    GradedAssignment gradedAssignment,
  ) {
    double total = rubric.totalPoints;
    if (total == 0) {
      return const Tuple2("", 0);
    }
    double finalScore = (calcEarnedPoints(rubric, gradedAssignment) -
            calcLatePenalty(rubric, gradedAssignment)) /
        total *
        100;
    String label = grader.gradingScale.scale[0].item1;
    for (int i = 0; i < grader.gradingScale.scale.length; i++) {
      if (grader.gradingScale.scale[i].item2 <= finalScore) {
        label = grader.gradingScale.scale[i].item1;
        break;
      }
    }
    return Tuple2(label, finalScore);
  }
}