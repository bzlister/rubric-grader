import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Late penalty:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, String>(
                  builder: (context, penalty, child) => Text(penalty),
                  selector: (context, rubric) => rubric.latePenalty == 0
                      ? "-"
                      : '-${rubric.latePenalty.toStringAsFixed(1)}',
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 2),
            ],
          ),
          Row(
            children: [
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
                    Tuple2<String, double> finalScore = rubric.calcGrade();
                    return '${finalScore.item1} (${finalScore.item2.toStringAsFixed(1)})';
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
