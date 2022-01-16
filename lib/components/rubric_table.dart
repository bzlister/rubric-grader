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
                    selector: (context, rubric) => rubric.grades.length,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, left: 2.0, bottom: 4),
                child: SizedBox(
                  width: leftColumnWidth,
                  height: 28,
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: const Text(
                        "+ Add",
                        style: TextStyle(fontSize: 11, color: Colors.white),
                      ),
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
    );
  }
}
