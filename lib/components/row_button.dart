import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ToggleButtonWidget extends StatefulWidget {
  final int index;
  final int len;
  final Factor category;
  final List<Factor> grades;
  final int total;

  const ToggleButtonWidget(
      {Key? key,
      required this.index,
      required this.len,
      required this.category,
      required this.grades,
      required this.total})
      : super(key: key);

  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List.filled(widget.len, false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 45,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: AutoSizeText(
                widget.category.label,
                style: const TextStyle(fontSize: 15),
                minFontSize: 9,
                maxLines: widget.category.label.contains(" ") ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )),
        Expanded(
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
        ),
      ],
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