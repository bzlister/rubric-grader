import 'package:flapp/components/grades_selector.dart';
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
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: SizedBox(
            height: 35,
            child: Row(
              children: [
                SizedBox(
                  width: leftColumnWidth,
                ),
                Expanded(
                  child: Selector<Rubric, int>(
                    builder: (context, length, child) => Row(
                      children: List.generate(
                        length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey,
                                  padding: const EdgeInsets.all(3),
                                ),
                                child: Selector<Rubric, double>(
                                  builder: (context, score, child) => Center(
                                      child: Text(
                                    "${score.truncate()}%",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )),
                                  selector: (context, rubric) =>
                                      rubric.getScore(index),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        const ScoresSelector(),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ),
                    selector: (context, rubric) => rubric.scores.length,
                  ),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: RubricTable(leftColumnWidth: leftColumnWidth)),
        SliverFillRemaining(
          hasScrollBody: false,
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                Selector<Rubric, bool>(
                  builder: (context, canShowSummary, child) => canShowSummary
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: const Summary(),
                        )
                      : const Center(
                          child: Text(
                              "Tap the '+' button to add a category to your rubric"),
                        ),
                  selector: (context, rubric) => rubric.totalPoints > 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
