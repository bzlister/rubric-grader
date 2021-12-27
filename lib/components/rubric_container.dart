import 'package:flapp/components/quantity_selector.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Row(
            children: [
              SizedBox(
                width: leftColumnWidth,
                /*
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    alignment: Alignment.bottomLeft,
                  ),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      const Text(
                        "Total points",
                        style: TextStyle(fontSize: 10),
                      ),
                      Selector<Rubric, double>(
                        builder: (context, totalPoints, child) =>
                            Text("${totalPoints.truncate()}"),
                        selector: (context, rubric) =>
                            rubric.totalPoints.weight,
                      )
                    ],
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const QuantitySelector.total(),
                  ),
                ),
                */
              ),
              Selector<Rubric, int>(
                builder: (context, length, child) => Expanded(
                  child: Row(
                    children: List.generate(
                      length,
                      (index) => Expanded(
                        child: GestureDetector(
                          child: Selector<Rubric, Factor>(
                            builder: (context, grade, child) => Column(
                              children: [
                                Text(grade.label),
                                Text("${grade.weight.truncate()}%"),
                              ],
                            ),
                            selector: (context, rubric) => rubric.grades[index],
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const QuantitySelector.grades(),
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
          RubricTable(leftColumnWidth: leftColumnWidth),
        ],
      ),
    );
  }
}
