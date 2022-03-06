import 'package:auto_size_text/auto_size_text.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/rubric/categories_selector.dart';
import 'package:flapp/routes/rubric/delete_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryContainer extends StatelessWidget {
  final double leftColumnWidth;
  final BoxConstraints constraints;
  final int length;
  final int rowNum;

  const CategoryContainer(
      {Key? key, required this.leftColumnWidth, required this.constraints, required this.length, required this.rowNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: leftColumnWidth,
      height: (constraints.maxWidth - leftColumnWidth) / length,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2, left: 2, top: 2),
        child: Selector<Rubric, Category>(
          builder: (context, category, child) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: AutoSizeText(
                    category.label,
                    maxFontSize: 12,
                    minFontSize: 7,
                    maxLines: category.label.contains(" ") ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AutoSizeText(
                  "${category.weight.truncate()}",
                  maxFontSize: 13,
                  minFontSize: 11,
                )
              ],
            ),
            onLongPress: () => showDialog(
              context: context,
              builder: (BuildContext context) => DeleteMenu(
                index: rowNum,
                categoryLabel: category.label,
              ),
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => CategoriesSelector.update(
                index: rowNum,
                initLabel: category.label,
                initWeight: category.weight,
              ),
            ),
          ),
          selector: (context, rubric) => rubric.getCategory(rowNum),
        ),
      ),
    );
  }
}
