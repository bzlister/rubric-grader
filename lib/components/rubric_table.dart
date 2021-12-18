import 'package:auto_size_text/auto_size_text.dart';
import 'package:flapp/components/row_button.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricTable extends StatelessWidget {
  const RubricTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Rubric>(
      builder: (context, rubric, child) => Wrap(
        children: List.generate(
          rubric.categories.length,
          (index) {
            Factor category = rubric.categories[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AutoSizeText(
                      category.label,
                      style: const TextStyle(fontSize: 15),
                      minFontSize: 9,
                      maxLines: category.label.contains(" ") ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                RowButton(
                    grades: rubric.grades,
                    worth:
                        rubric.categories[index].weight * rubric.totalPoints),
              ],
            );
          },
        ),
      ),
    );
  }
}
