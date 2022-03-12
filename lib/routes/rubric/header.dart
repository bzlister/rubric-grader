import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xid/xid.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<Rubric, Xid>(
          builder: (context, _, child) {
            return TextFormField(
              controller: TextEditingController(text: context.read<Rubric>().assignmentName),
              decoration: InputDecoration(
                hintText: context.read<Grader>().defaultAssignmentName,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              onChanged: (value) {
                context.read<Rubric>().assignmentName = value;
              },
              textInputAction: TextInputAction.go,
            );
          },
          selector: (context, rubric) => rubric.xid,
        ),
        Selector<GradedAssignment, Xid>(
          builder: (context, _, child) {
            return TextFormField(
              controller: TextEditingController(text: context.read<GradedAssignment>().name),
              decoration: InputDecoration(
                hintText: context.read<Rubric>().defaultStudentName,
                isDense: true,
              ),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
              onChanged: (value) {
                context.read<GradedAssignment>().name = value;
              },
              textInputAction: TextInputAction.go,
            );
          },
          selector: (context, gradedAssignment) => gradedAssignment.xid,
        ),
      ],
    );
  }
}
