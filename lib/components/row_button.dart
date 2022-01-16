import 'package:auto_size_text/auto_size_text.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'categories_selector.dart';
import 'delete_menu.dart';

class RowButton extends StatelessWidget {
  final int rowNum;
  final int length;
  final double leftColumnWidth;

  const RowButton(
      {Key? key,
      required this.rowNum,
      required this.length,
      required this.leftColumnWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Selector<Rubric, List<bool>>(
        builder: (context, isSelected, child) => Row(
          children: [
            SizedBox(
              width: leftColumnWidth,
              height: (constraints.maxWidth - leftColumnWidth) / length,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2, left: 2, top: 2),
                child: Selector<Rubric, Factor>(
                  builder: (context, category, child) => TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.amber),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            category.label,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white),
                            maxLines: category.label.contains(" ") ? 2 : 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "${category.weight.truncate()}",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
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
                      builder: (BuildContext context) =>
                          CategoriesSelector.update(
                        index: rowNum,
                        initLabel: category.label,
                        initWeight: category.weight,
                      ),
                    ),
                  ),
                  selector: (context, rubric) => rubric.getCategory(rowNum),
                ),
              ),
            ),
            ToggleButtons(
              constraints: BoxConstraints.expand(
                width: (constraints.maxWidth - leftColumnWidth) / length,
                height: (constraints.maxWidth - leftColumnWidth) / length,
              ),
              renderBorder: true,
              borderWidth: 0,
              children: List.generate(
                length,
                (index) => Selector<Rubric, String>(
                    builder: (context, value, child) =>
                        Text(isSelected[index] ? value : "-"),
                    selector: (context, rubric) => (0.01 *
                            rubric.getCategory(rowNum).weight *
                            rubric.getGrade(index).weight)
                        .toStringAsFixed(1)),
              ),
              isSelected: isSelected,
              onPressed: (index) {
                if (isSelected[index] == false) {
                  context.read<Rubric>().makeSelection(rowNum, index);
                } else {
                  context.read<Rubric>().cancelSelection(rowNum, index);
                }
              },
            ),
          ],
        ),
        selector: (context, rubric) {
          int indx = rubric.getSelection(rowNum);
          List<bool> isSelected = List.filled(length, false);
          if (indx != -1) {
            isSelected[indx] = true;
          }
          return isSelected;
        },
      );
    });
  }
}

/*
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        )
*/