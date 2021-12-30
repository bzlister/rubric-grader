import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  final double width = 110;
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Total:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, double>(
                  builder: (context, total, child) => Text(
                    total.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 15),
                  ),
                  selector: (context, rubric) => rubric.totalPoints,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Earned:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, double>(
                  builder: (context, earned, child) => Text(
                    earned.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 15),
                  ),
                  selector: (context, rubric) => rubric.earnedPoints,
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Grade:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, String>(
                  builder: (context, letterGradeText, child) => Text(
                    letterGradeText,
                    style: const TextStyle(fontSize: 15),
                  ),
                  selector: (context, rubric) {
                    if (rubric.totalPoints > 0) {
                      double score =
                          rubric.earnedPoints / rubric.totalPoints * 100;
                      String letterGrade = rubric.grades.last.label;
                      for (int i = 0; i < rubric.grades.length; i++) {
                        if (rubric.grades[i].weight <= score) {
                          letterGrade = rubric.grades[i].label;
                          break;
                        }
                      }
                      return "$letterGrade (${score.toStringAsFixed(1)}%)";
                    } else {
                      return "-";
                    }
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
