import 'package:flapp/interval.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';

class GradingScaleSelector extends StatefulWidget {
  final Interval interval;
  final double min;
  final double max;
  final void Function(RangeValues) onIntervalChange;
  final void Function(String) onLetterGradeChange;
  final void Function()? onRemove;
  final void Function(bool) onAdd;

  const GradingScaleSelector({
    Key? key,
    required this.interval,
    required this.min,
    required this.max,
    required this.onIntervalChange,
    required this.onLetterGradeChange,
    required this.onRemove,
    required this.onAdd,
  }) : super(key: key);

  @override
  _GradingScaleSelectorState createState() => _GradingScaleSelectorState();
}

class _GradingScaleSelectorState extends State<GradingScaleSelector> {
  late RangeValues _rangeValues;
  late String _letterGrade;
  late bool endLocked;
  late bool startLocked;

  @override
  void initState() {
    _letterGrade = widget.interval.letterGrade;
    _rangeValues = RangeValues(widget.interval.lower, widget.interval.upper);
    endLocked = _rangeValues.end == 100;
    startLocked = _rangeValues.start == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: TextField(
                  decoration: const InputDecoration(contentPadding: EdgeInsets.zero, isDense: true, isCollapsed: true),
                  keyboardType: TextInputType.text,
                  controller: TextEditingController(text: _letterGrade),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^[A-Za-z]{1,2}[-+]?$")),
                    LengthLimitingTextInputFormatter(3)
                  ],
                  onSubmitted: (val) {
                    widget.onLetterGradeChange(val);
                    setState(() {
                      _letterGrade = val.toUpperCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: RangeSlider(
                  values: _rangeValues,
                  divisions: (widget.max - widget.min).toInt() * 10,
                  labels: RangeLabels(
                    _rangeValues.start.toStringAsFixed(1),
                    _rangeValues.end.toStringAsFixed(1),
                  ),
                  onChanged: (rV) {
                    setState(() {
                      if (endLocked) {
                        _rangeValues = RangeValues(rV.start, _rangeValues.end);
                      } else if (startLocked) {
                        _rangeValues = RangeValues(_rangeValues.start, rV.end);
                      } else {
                        _rangeValues = rV;
                      }
                    });
                  },
                  onChangeEnd: (_) {
                    widget.onIntervalChange(RangeValues(
                        (_rangeValues.start * 10).roundToDouble() / 10, (_rangeValues.end * 10).roundToDouble() / 10));
                  },
                  min: widget.min,
                  max: widget.max,
                ),
              ),
              Column(
                children: [
                  IconButton(
                      onPressed: () {
                        widget.onAdd(true);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        widget.onRemove?.call();
                        Navigator.of(context).pop();
                      },
                      disabledColor: Colors.grey,
                      icon: Icon(Icons.delete_forever)),
                  IconButton(
                      onPressed: () {
                        widget.onAdd(false);
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.add)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
