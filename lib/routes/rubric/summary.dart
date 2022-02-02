import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/routes/rubric/late_penalty_selector.dart';
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Selector<GradedAssignment, double>(
                  builder: (context, earned, child) => Text(
                    earned.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 16),
                  ),
                  selector: (context, gradedAssignment) =>
                      gradedAssignment.earnedPoints,
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Selector<GradedAssignment, String>(
                    builder: (context, latePenaltyText, child) => Text(
                      latePenaltyText,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    selector: (context, gradedAssignment) =>
                        '- ${gradedAssignment.latePenalty.toStringAsFixed(1)}',
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Selector2<Grader, GradedAssignment, String>(
                  builder: (context, letterGradeText, child) => Text(
                    letterGradeText,
                    style: const TextStyle(fontSize: 16),
                  ),
                  selector: (context, grader, gradedAssignment) {
                    Tuple2<String, double> finalScore =
                        gradedAssignment.calcGrade(grader.gradingScale);
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
          child: Selector<GradedAssignment, String>(
            builder: (context, comment, child) => TextFormField(
              controller: TextEditingController(
                  text: comment), // see if wrapping in Selector here works
              style: const TextStyle(
                  fontStyle: FontStyle.italic, decorationThickness: 0),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(hintText: "Add a comment"),
              onFieldSubmitted: (value) =>
                  context.read<GradedAssignment>().comment = value,
            ),
            selector: (context, gradedAssignment) =>
                gradedAssignment.comment ?? "",
          ),
        )
      ],
    );
  }
}
