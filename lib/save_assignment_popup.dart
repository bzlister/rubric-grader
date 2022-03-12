import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveAssignmentPopup extends StatefulWidget {
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
  _SaveAssignmentPopupState createState() => _SaveAssignmentPopupState();
}

class _SaveAssignmentPopupState extends State<SaveAssignmentPopup> {
  late String? _name;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _name = widget.gradedAssignment.name;
    _controller = TextEditingController(text: _name);
  }

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
            widget.gradedAssignment.name = _name ?? widget.rubric.defaultStudentName;
            widget.rubric.saveGradedAssignment(widget.gradedAssignment);
            widget.grader.saveRubric(widget.rubric);
            if (widget.resetRubric) {
              widget.rubric.reset(widget.grader.defaultAssignmentName);
            }
            widget.gradedAssignment.reset();
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (widget.resetRubric) {
              widget.rubric.reset(widget.grader.defaultAssignmentName);
            }
            widget.gradedAssignment.reset();
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
