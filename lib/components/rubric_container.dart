import 'package:flapp/components/grades_selector.dart';
import 'package:flapp/components/late_penalty_selector.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/components/summary.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatelessWidget {
  final double leftColumnWidth = 85;

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
                    child: GestureDetector(
                      child: Row(
                        children: List.generate(
                          length,
                          (index) => Expanded(
                            child: Selector<Rubric, double>(
                              builder: (context, score, child) => Center(
                                  child: Text(
                                "${score.truncate()}%",
                                style: const TextStyle(fontSize: 15),
                              )),
                              selector: (context, rubric) =>
                                  rubric.getScore(index),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const ScoresSelector(),
                        );
                      },
                    ),
                  ),
                  selector: (context, rubric) => rubric.scores.length,
                )
              ],
            ),
          ),
          RubricTable(leftColumnWidth: leftColumnWidth),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Selector<Rubric, double>(
                  builder: (context, totalPoints, child) => Text(
                    "Total: ${totalPoints.toStringAsFixed(1)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  selector: (context, rubric) => rubric.totalPoints,
                ),
                const Expanded(
                  child: Divider(
                    thickness: 2,
                    indent: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: LatePenaltySelector(),
          ),
          Selector<Rubric, bool>(
            builder: (context, canShowSummary, child) =>
                canShowSummary ? const Summary() : Container(),
            selector: (context, rubric) => rubric.totalPoints > 0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 35,
              child: Selector<Rubric, String>(
                builder: (context, comment, child) => TextFormField(
                  controller: TextEditingController(text: comment),
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, decorationThickness: 0),
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(hintText: "Add a comment"),
                  onFieldSubmitted: (value) =>
                      context.read<Rubric>().comment = value,
                ),
                selector: (context, rubric) => rubric.comment,
              ),
            ),
          )
        ],
      ),
    );
  }
}
