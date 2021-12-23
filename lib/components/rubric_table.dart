import 'package:auto_size_text/auto_size_text.dart';
import 'package:flapp/components/row_button.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricTable extends StatelessWidget {
  final double leftColumnWidth;

  const RubricTable({Key? key, required this.leftColumnWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<Rubric, int>(
      builder: (context, length, child) => Wrap(
        children: List.generate(
          length,
          (index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: leftColumnWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Selector<Rubric, String>(
                      builder: (context, label, child) => AutoSizeText(
                        label,
                        style: const TextStyle(fontSize: 15),
                        minFontSize: 9,
                        maxLines: label.contains(" ") ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      selector: (context, rubric) =>
                          rubric.categories[index].label,
                    ),
                  ),
                ),
                Selector<Rubric, int>(
                  builder: (context, lngth, child) =>
                      RowButton(rowNum: index, length: lngth),
                  selector: (context, rubric) => rubric.grades.length,
                )
              ],
            );
          },
        ),
      ),
      selector: (context, rubric) => rubric.categories.length,
    );
  }
}
