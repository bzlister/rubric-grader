import 'package:flapp/grading_scale.dart';
import 'package:flapp/interval.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/routes/options/grading_scale_menu.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';

class GradingScaleOption extends StatelessWidget {
  const GradingScaleOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Grading scale"),
        Selector<Grader, GradingScale>(
          builder: (context, gradingScale, child) {
            return TextButton(
              child: Text(gradingScale.name),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => GradingScaleMenu(
                    gradingScale: gradingScale,
                  ),
                );
              },
            );
          },
          selector: (context, grader) => grader.gradingScale,
        )
      ],
    );
  }
}
