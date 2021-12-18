import 'dart:collection';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';

class RowButton extends StatefulWidget {
  final UnmodifiableListView<Factor> grades;
  final double worth;
  final int len;

  const RowButton({Key? key, required this.grades, required this.worth})
      : len = grades.length,
        super(key: key);

  @override
  _RowButtonState createState() => _RowButtonState();
}

class _RowButtonState extends State<RowButton> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.grades.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        return ToggleButtons(
          constraints: BoxConstraints.expand(
            width: constraints.maxWidth / widget.len,
            height: constraints.maxWidth / widget.len,
          ),
          renderBorder: false,
          children: List.filled(widget.len, Text("-")),
          isSelected: _isSelected,
          onPressed: (index) {
            setState(() {
              _isSelected = List.filled(widget.len, false);
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