import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';

class RubricTemplate extends StatefulWidget {
  const RubricTemplate(
      {Key? key,
      required this.categories,
      required this.grades,
      required this.totalPoints})
      : super(key: key);

  final List<Factor> categories;
  final List<Factor> grades;
  final int totalPoints;

  @override
  State<RubricTemplate> createState() => _RubricTemplateState();
}

class _RubricTemplateState extends State<RubricTemplate> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: List.generate(
            3, (index) => ToggleButtonWidget(isFirst: true, index: index)));
  }
}

class ToggleButtonWidget extends StatefulWidget {
  final bool isFirst;
  final int index;

  const ToggleButtonWidget(
      {Key? key, this.isFirst = false, required this.index})
      : super(key: key);

  @override
  _ToggleButtonWidgetState createState() => _ToggleButtonWidgetState();
}

class _ToggleButtonWidgetState extends State<ToggleButtonWidget> {
  late List<bool> _isSelected;

  @override
  void initState() {
    _isSelected = [widget.isFirst ? true : false];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ToggleButtons(
        renderBorder: false,
        constraints: BoxConstraints.expand(
            width: constraints.maxWidth / 3, height: constraints.maxWidth / 3),
        borderRadius: BorderRadius.circular(5),
        children: [
          Text('Option1-' + widget.index.toString()),
          Text('Option2-' + widget.index.toString()),
          Text('Option3-' + widget.index.toString())
        ],
        isSelected: [false, false, false],
        onPressed: (index) {},
      );
    });
  }
}
