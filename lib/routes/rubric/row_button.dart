import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/rubric/category_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xid/xid.dart';

class RowButton extends StatelessWidget {
  final int rowNum;
  final int length;
  final double leftColumnWidth;

  const RowButton({Key? key, required this.rowNum, required this.length, required this.leftColumnWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Selector2<Rubric, GradedAssignment, List<bool>>(
        builder: (context, isSelected, child) => Row(
          children: [
            CategoryContainer(
              leftColumnWidth: leftColumnWidth,
              constraints: constraints,
              length: length,
              rowNum: rowNum,
            ),
            ToggleButtons(
              constraints: BoxConstraints.expand(
                width: (constraints.maxWidth - leftColumnWidth - isSelected.length - 1) / length,
                height: (constraints.maxWidth - leftColumnWidth - isSelected.length - 1) / length,
              ),
              renderBorder: true,
              borderWidth: 1,
              children: List.generate(
                length,
                (index) => Selector<Rubric, String>(
                    builder: (context, value, child) => Text(isSelected[index] ? value : "-"),
                    selector: (context, rubric) =>
                        (0.01 * rubric.getCategory(rowNum).weight * rubric.getScore(index)).toStringAsFixed(1)),
              ),
              isSelected: isSelected,
              onPressed: (index) {
                if (isSelected[index] == false) {
                  context.read<GradedAssignment>().select(
                        context.read<Rubric>().getCategory(rowNum).xid,
                        context.read<Rubric>().scoreBins[index].xid,
                      );
                } else {
                  context.read<GradedAssignment>().deselect(
                        context.read<Rubric>().getCategory(rowNum).xid,
                      );
                }
              },
            ),
          ],
        ),
        selector: (context, rubric, gradedAssignment) {
          Xid? selected = gradedAssignment.getSelection(rubric.getCategory(rowNum).xid);
          List<bool> isSelected = List.filled(length, false);
          if (selected != null) {
            int? indx = rubric.getScoreIndexByXid(selected);
            if (indx != null) {
              isSelected[indx] = true;
            }
          }
          return isSelected;
        },
      );
    });
  }
}
