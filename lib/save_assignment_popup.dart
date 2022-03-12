import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveAssignmentPopup extends StatelessWidget {
  final Grader grader;
  final Rubric rubric;
  final GradedAssignment gradedAssignment;
  final bool resetRubric;
  final bool canShowWarning;

  const SaveAssignmentPopup(
      {Key? key,
      required this.grader,
      required this.rubric,
      required this.gradedAssignment,
      required this.resetRubric,
      required this.canShowWarning})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: Selector2<Rubric, GradedAssignment, String>(
          builder: (context, str, child) => Text(str),
          selector: (context, rubric, gradedAssignment) =>
              'Save changes to ${gradedAssignment.name ?? rubric.defaultStudentName}\'s ${rubric.assignmentName}?',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            gradedAssignment.name ??= rubric.defaultStudentName;
            rubric.saveGradedAssignment(gradedAssignment);
            rubric.assignmentName ??= grader.defaultAssignmentName;
            grader.saveRubric(rubric);
            if (resetRubric) {
              rubric.reset();
            }
            gradedAssignment.reset();
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (resetRubric) {
              rubric.reset();
            }
            gradedAssignment.reset();
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
    );
  }
}
