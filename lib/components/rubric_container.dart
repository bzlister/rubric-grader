import 'package:flapp/components/grades_selector.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class RubricContainer extends StatelessWidget {
  final double leftColumnWidth = 70;

  const RubricContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                SizedBox(
                  width: leftColumnWidth,
                ),
                Selector<Rubric, int>(
                  builder: (context, length, child) => Expanded(
                    child: Row(
                      children: List.generate(
                        length,
                        (index) => Expanded(
                          child: GestureDetector(
                            child: Selector<Rubric, Tuple2<String, double>>(
                              builder: (context, grade, child) => Column(
                                children: [
                                  Text(grade.item1),
                                  Text("${grade.item2.truncate()}%"),
                                ],
                              ),
                              selector: (context, rubric) =>
                                  rubric.getGrade(index),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    const GradesSelector(),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  selector: (context, rubric) => rubric.grades.length,
                )
              ],
            ),
          ),
          RubricTable(leftColumnWidth: leftColumnWidth),
        ],
      ),
    );
  }
}
