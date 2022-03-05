import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget {
  final String assignmentName;
  final String studentName;

  const Header({Key? key, required this.assignmentName, required this.studentName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late TextEditingController _assignmentNameController;
  late TextEditingController _studentNameController;

  @override
  void initState() {
    _assignmentNameController = TextEditingController(text: widget.assignmentName);
    _studentNameController = TextEditingController(text: widget.studentName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            isDense: true,
          ),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          onSubmitted: (value) {
            context.read<Rubric>().assignmentName = value;
          },
          onChanged: (value) {
            context.read<Rubric>().assignmentName = value;
          },
          textInputAction: TextInputAction.go,
          controller: _assignmentNameController,
        ),
        TextField(
          decoration: const InputDecoration(
            isDense: true,
          ),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          onSubmitted: (value) {
            context.read<GradedAssignment>().name = value;
          },
          onChanged: (value) {
            context.read<GradedAssignment>().name = value;
          },
          textInputAction: TextInputAction.go,
          controller: _studentNameController,
        ),
      ],
    );
  }
}
