import 'package:flutter/material.dart';

class GradingScaleOption extends StatelessWidget {
  const GradingScaleOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Grading scale"),
        TextButton(
          child: Text("College Board"),
          onPressed: () {},
        )
      ],
    );
  }
}
