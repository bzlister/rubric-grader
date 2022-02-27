import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveAssignmentPopup extends StatefulWidget {
  final Grader grader;
  final Rubric rubric;
  final GradedAssignment gradedAssignment;

  const SaveAssignmentPopup({Key? key, required this.grader, required this.rubric, required this.gradedAssignment})
      : super(key: key);

  @override
  _SaveAssignmentPopupState createState() => _SaveAssignmentPopupState();
}

class _SaveAssignmentPopupState extends State<SaveAssignmentPopup> {
  late String _name;
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
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("Save graded ${context.read<Rubric>().assignmentName}?"),
            IntrinsicWidth(
              child: TextField(
                keyboardType: TextInputType.text,
                maxLength: 30,
                onChanged: (value) {
                  setState(() {
                    _name = value.trim();
                  });
                },
                maxLines: 1,
                autofocus: widget.rubric.defaultStudentName == widget.gradedAssignment.name,
                decoration: const InputDecoration(labelText: "Student name:"),
                onSubmitted: (value) => widget.gradedAssignment.name = value,
                textInputAction: TextInputAction.go,
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            widget.gradedAssignment.name = _name;
            widget.rubric.saveGradedAssignment(widget.gradedAssignment);
            widget.grader.saveRubric(widget.rubric);
            widget.rubric.reset(widget.grader.defaultAssignmentName);
            widget.gradedAssignment.reset(context.read<Rubric>().defaultStudentName);
          },
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (widget.rubric.assignmentName == widget.grader.defaultAssignmentName) {
              widget.grader.incrementOffset();
            }
            widget.rubric.reset(widget.grader.defaultAssignmentName);
            widget.gradedAssignment.reset(context.read<Rubric>().defaultStudentName);
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
