import 'package:flapp/components/quantity_selector.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatelessWidget {
  final double leftColumnWidth = 65;

  const RubricContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<Rubric>(
          builder: (context, rubric, child) => SizedBox(
            height: 35,
            child: TextField(
              onSubmitted: (value) {
                rubric.setAssignmentName(value);
              },
              textInputAction: TextInputAction.go,
              controller: TextEditingController(text: rubric.assignmentName),
            ),
          ),
        ),
        Consumer<Rubric>(
          builder: (context, rubric, child) => Row(
            children: [
              SizedBox(
                width: leftColumnWidth,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.black, alignment: Alignment.bottomLeft),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      const Text(
                        "Total Points",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text("${rubric.totalPoints}")
                    ],
                  ),
                  onPressed: () => print("total points"),
                ),
              ),
              ...List.generate(rubric.grades.length, (index) {
                Factor grade = rubric.grades[index];
                return Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(primary: Colors.black),
                    child: Column(
                      children: [
                        Text(grade.label),
                        Text("${grade.weight.truncate()}%"),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            const QuantitySelector.grades(),
                      );
                    },
                  ),
                );
              })
            ],
          ),
        ),
        RubricTable(leftColumnWidth: leftColumnWidth),
      ],
    );
  }
}
