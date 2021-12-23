import 'dart:collection';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowButton extends StatefulWidget {
  final int rowNum;
  final int length;

  const RowButton({Key? key, required this.rowNum, required this.length})
      : super(key: key);

  @override
  _RowButtonState createState() => _RowButtonState();
}

class _RowButtonState extends State<RowButton> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / widget.length,
            height: constraints.maxWidth / widget.length,
          ),
          renderBorder: false,
          children: List.generate(
              widget.length,
              (index) => Selector<Rubric, int>(
                  builder: (context, value, child) =>
                      Text(_isSelected[index] ? value.toString() : "-"),
                  selector: (context, rubric) => (0.0001 *
                          rubric.totalPoints *
                          rubric.categories[widget.rowNum].weight *
                          rubric.grades[index].weight)
                      .toInt())),
          isSelected: _isSelected,
          onPressed: (index) {
            setState(() {
              _isSelected = List.filled(widget.length, false);
              _isSelected[index] = true;
            });
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