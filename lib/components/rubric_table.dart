import 'package:flapp/components/row_button.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'categories_selector.dart';

class RubricTable extends StatelessWidget {
  final double leftColumnWidth;

  const RubricTable({Key? key, required this.leftColumnWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.1,
      child: Column(
        children: [
          SingleChildScrollView(
            child: Selector<Rubric, int>(
              builder: (context, length, child) => Wrap(
                children: [
                  ...List.generate(
                    length,
                    (index) {
                      return Selector<Rubric, int>(
                        builder: (context, lngth, child) => RowButton(
                          rowNum: index,
                          length: lngth,
                          leftColumnWidth: leftColumnWidth,
                        ),
                        selector: (context, rubric) => rubric.scores.length,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SizedBox(
                      width: leftColumnWidth,
                      height: 28,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            primary: Colors.amber,
                            onPrimary: Colors.black),
                        child: const Text(
                          "+",
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CategoriesSelector.add(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              selector: (context, rubric) => rubric.categories.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: [
                Selector<Rubric, double>(
                  builder: (context, totalPoints, child) => Text(
                    "Total: ${totalPoints.toStringAsFixed(1)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  selector: (context, rubric) => rubric.totalPoints,
                ),
                const Expanded(
                  child: Divider(
                    thickness: 2,
                    indent: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
