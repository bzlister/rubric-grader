import 'package:auto_size_text/auto_size_text.dart';
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
      height: MediaQuery.of(context).size.height / 2,
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
              SizedBox(
                width: leftColumnWidth,
                child: ElevatedButton(
                  child: const Center(
                    child: Text("+"),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => CategoriesSelector.add(),
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
