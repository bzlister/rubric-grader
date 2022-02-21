import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/grader.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';

class GradingScaleOption extends StatelessWidget {
  const GradingScaleOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Grading scale"),
        TextButton(
          child: Text("College Board"),
          onPressed: () {
            context.read<Grader>().gradingScale = GradingScale(scale: [
              Tuple2("O", 90),
              Tuple2("A", 80),
              Tuple2("N", 70),
            ]);
          },
        )
      ],
    );
  }
}
