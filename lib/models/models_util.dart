import 'dart:math';

import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/save_assignment_popup.dart';
import 'package:flutter/material.dart';
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
    double percentageOff = gradedAssignment.daysLate * rubric.latePercentagePerDay * 0.01;
    double earnedPoints = calcEarnedPoints(rubric, gradedAssignment);
    return min(
      percentageOff * (rubric.latePolicy == "total" ? rubric.totalPoints : earnedPoints),
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
    double finalScore =
        (calcEarnedPoints(rubric, gradedAssignment) - calcLatePenalty(rubric, gradedAssignment)) / total * 100;
    String label = grader.gradingScale.scale[0].item1;
    for (int i = 0; i < grader.gradingScale.scale.length; i++) {
      if (grader.gradingScale.scale[i].item2 <= finalScore) {
        label = grader.gradingScale.scale[i].item1;
        break;
      }
    }
    return Tuple2(label, finalScore);
  }

  static EditedStatus isEdited(Grader grader, Rubric rubric, GradedAssignment gradedAssignment) {
    bool rubricEdited = false;
    bool assignmentEdited = false;
    Rubric? oldRubric = grader.findRubricByXid(rubric.xid);
    String oldRubricState = oldRubric?.getState() ?? Rubric.empty(grader.defaultAssignmentName).getState();
    String oldAssignmentState = oldRubric?.findGradedAssignmentByXid(gradedAssignment.xid)?.getState() ??
        GradedAssignment.empty(rubric.defaultStudentName).getState();
    rubricEdited = rubric.getState() != oldRubricState;
    assignmentEdited = gradedAssignment.getState() != oldAssignmentState;

    if (rubricEdited && assignmentEdited) {
      return EditedStatus.rubricAndAssignment;
    }

    if (!rubricEdited && assignmentEdited) {
      return EditedStatus.assignment;
    }

    if (rubricEdited && !assignmentEdited) {
      return EditedStatus.rubric;
    }

    return EditedStatus.none;
  }

  static void onSave(
      Grader grader, Rubric rubric, GradedAssignment gradedAssignment, BuildContext context, bool resetRubric) {
    EditedStatus editedStatus = ModelsUtil.isEdited(grader, rubric, gradedAssignment);

    switch (editedStatus) {
      case EditedStatus.none:
        if (rubric.assignmentName == grader.defaultAssignmentName) {
          grader.incrementOffset();
        }
        rubric.reset(grader.defaultAssignmentName);
        break;
      case EditedStatus.assignment:
        showDialog(
          context: context,
          builder: (BuildContext context) => SaveAssignmentPopup(
            grader: grader,
            rubric: rubric,
            gradedAssignment: gradedAssignment,
            resetRubric: resetRubric,
          ),
        );
        break;
      case EditedStatus.rubric:
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: IntrinsicHeight(
              child: Column(
                children: [
                  Text(
                    "Save rubric '${rubric.assignmentName}'?",
                  ),
                  Visibility(
                    visible: rubric.gradedAssignments.isNotEmpty,
                    child: const Text(
                      "You have already graded assignments with this rubric. Saving changes to the rubric may cause scores to be recalculated.",
                      style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  grader.saveRubric(rubric);
                  if (resetRubric) {
                    rubric.reset(grader.defaultAssignmentName);
                  }
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (rubric.assignmentName == grader.defaultAssignmentName) {
                    grader.incrementOffset();
                  }
                  if (resetRubric) {
                    rubric.reset(grader.defaultAssignmentName);
                  }
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              )
            ],
          ),
        );
        break;
      case EditedStatus.rubricAndAssignment:
        showDialog(
          context: context,
          builder: (BuildContext context) => SaveAssignmentPopup(
            grader: grader,
            rubric: rubric,
            gradedAssignment: gradedAssignment,
            resetRubric: resetRubric,
          ),
        );
        break;
    }
  }
}

enum EditedStatus { none, rubric, assignment, rubricAndAssignment }
