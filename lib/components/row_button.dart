import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowButton extends StatelessWidget {
  final int rowNum;
  final int length;

  const RowButton({Key? key, required this.rowNum, required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return Selector<Rubric, List<bool>>(
          builder: (context, isSelected, child) => ToggleButtons(
            constraints: BoxConstraints.expand(
              width: constraints.maxWidth / length,
              height: constraints.maxWidth / length,
            ),
            renderBorder: false,
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
          selector: (context, rubric) {
            int indx = rubric.getSelection(rowNum);
            List<bool> isSelected = List.filled(length, false);
            if (indx != -1) {
              isSelected[indx] = true;
            }
            return isSelected;
          },
        );
      }),
    );
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