import 'package:flapp/components/grades_selector.dart';
import 'package:flapp/components/late_penalty_selector.dart';
import 'package:flapp/components/menu.dart';
import 'package:flapp/components/rubric_table.dart';
import 'package:flapp/components/summary.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatefulWidget {
  const RubricContainer({Key? key}) : super(key: key);

  @override
  State<RubricContainer> createState() => _RubricContainerState();
}

class _RubricContainerState extends State<RubricContainer> {
  final double leftColumnWidth = 85;
  late bool _showMenu;

  @override
  void initState() {
    super.initState();
    _showMenu = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Selector<Rubric, double>(
                              builder: (context, score, child) => Center(
                                  child: Text(
                                "${score.truncate()}%",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              )),
                              selector: (context, rubric) =>
                                  rubric.getScore(index),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const ScoresSelector(),
                    );
                  },
                ),
              ),
              selector: (context, rubric) => rubric.scores.length,
            )
          ],
        ),
        RubricTable(leftColumnWidth: leftColumnWidth),
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: LatePenaltySelector(),
        ),
        const Spacer(),
        Selector<Rubric, bool>(
          builder: (context, canShowSummary, child) =>
              canShowSummary ? const Summary() : Container(),
          selector: (context, rubric) => rubric.totalPoints > 0,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
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
    );
  }
}
