import 'package:flapp/components/late_penalty_selector.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Summary extends StatelessWidget {
  final double width = 110;
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 22,
          child: Row(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Earned:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Align(
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
        ),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Late penalty:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, double>(
                  builder: (context, penalty, child) => TextButton(
                    child: Text(
                      '- $penalty',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          const LatePenaltySelector(),
                    ),
                  ),
                  selector: (context, rubric) => rubric.latePenalty,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 2),
            ],
          ),
        ),
        SizedBox(
          height: 22,
          child: Row(
            children: [
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Grade:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Align(
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
        ),
        SizedBox(
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
        )
      ],
    );
  }
}
