import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:xid/xid.dart';

class DeletePopup extends StatelessWidget {
  final List<GradedAssignment> assignmentsToDelete;
  final Rubric containingRubric;

  const DeletePopup({Key? key, required this.containingRubric, required this.assignmentsToDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: assignmentsToDelete.length > 1
          ? Text(
              "Delete ${assignmentsToDelete.length} graded assignments in rubric ${containingRubric.assignmentName}?")
          : Text("Delete ${assignmentsToDelete[0].name}'s ${containingRubric.assignmentName}?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            List<Xid> xids = assignmentsToDelete.map((a) => a.xid).toList();
            bool couldDeleteRubric = assignmentsToDelete.length == containingRubric.gradedAssignments.length;
            containingRubric.deleteGradedAssignments(xids);
            Grader grader = context.read<Grader>();
            containingRubric.assignmentName ??= grader.defaultAssignmentName;
            grader.saveRubric(containingRubric);
            if (xids.contains(context.read<GradedAssignment>().xid)) {
              context.read<GradedAssignment>().reset();
            }
            if (couldDeleteRubric) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text("Delete rubric ${containingRubric.assignmentName}?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                grader.deleteRubric(containingRubric);
                                if (context.read<Rubric>().xid == containingRubric.xid) {
                                  context.read<Rubric>().reset();
                                }
                              },
                              child: const Text("Yes")),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"))
                        ],
                      ));
            }
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        )
      ],
    );
  }
}
