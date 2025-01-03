import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/rubric/row_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'categories_selector.dart';

class RubricTable extends StatelessWidget {
  final double leftColumnWidth;

  const RubricTable({Key? key, required this.leftColumnWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
          child: SingleChildScrollView(
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
                        selector: (context, rubric) => rubric.scoreBins.length,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: leftColumnWidth,
                        height: 28,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              foregroundColor: Colors.orange,
                              backgroundColor: Colors.black),
                          child: const Icon(
                            Icons.add_box,
                            color: Colors.white70,
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const CategoriesSelector.add(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              selector: (context, rubric) => rubric.categories.length,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: 20,
            child: Row(
              children: [
                Selector<Rubric, double>(
                  builder: (context, totalPoints, child) {
                    return Text(
                      "Total: ${totalPoints.toStringAsFixed(1)}",
                      style: const TextStyle(fontSize: 16),
                    );
                  },
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
        ),
      ],
    );
  }
}
