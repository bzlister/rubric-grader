import 'package:flapp/components/quantity_selector.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatefulWidget {
  const RubricContainer({Key? key}) : super(key: key);

  @override
  State<RubricContainer> createState() => _RubricContainerState();
}

class _RubricContainerState extends State<RubricContainer> {
  final double leftColumnWidth = 45;

  @override
  void initState() {
    super.initState();
    // default starting rubric
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: leftColumnWidth,
              child: Consumer<Rubric>(
                builder: (context, rubric, child) =>
                    Text("Total Points: ${rubric.totalPoints}"),
              ),
            ),
            grader(""),
            grader(""),
            grader(""),
            grader(""),
            grader(""),
          ],
        ),
        RubricTable(),
      ],
    );
  }

  Widget grader(textVar) {
    return Expanded(
        child: ElevatedButton(
      child: Text(
        textVar,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => QuantitySelector(
            onChanged: (value) {
              setState(() {
                textVar = value.toString();
              });
            },
          ),
        );
      },
    ));
  }
}
