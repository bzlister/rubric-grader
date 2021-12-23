import 'dart:collection';

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
        Selector<Rubric, String>(
          builder: (context, assignmentName, child) => SizedBox(
            height: 35,
            child: TextField(
              onSubmitted: (value) {
                context.read<Rubric>().setAssignmentName(value);
              },
              textInputAction: TextInputAction.go,
              controller: TextEditingController(text: assignmentName),
            ),
          ),
          selector: (context, rubric) => rubric.assignmentName,
        ),
        Row(
          children: [
            SizedBox(
              width: leftColumnWidth,
              child: TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black,
                  alignment: Alignment.bottomLeft,
                ),
                child: Wrap(
                  direction: Axis.vertical,
                  children: [
                    const Text(
                      "Total Points",
                      style: TextStyle(fontSize: 10),
                    ),
                    Selector<Rubric, int>(
                      builder: (context, totalPoints, child) =>
                          Text("$totalPoints"),
                      selector: (context, rubric) => rubric.totalPoints,
                    )
                  ],
                ),
                onPressed: () => print("total points"),
              ),
            ),
            Selector<Rubric, UnmodifiableListView<Factor>>(
              builder: (context, grades, child) => Expanded(
                child: Row(
                  children: List.generate(grades.length, (index) {
                    Factor grade = grades[index];
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
                  }),
                ),
              ),
              selector: (context, rubric) => rubric.grades,
            )
          ],
        ),
        RubricTable(leftColumnWidth: leftColumnWidth),
      ],
    );
  }
}
