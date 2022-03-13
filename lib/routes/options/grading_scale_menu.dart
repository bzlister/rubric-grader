import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/routes/options/grading_scale_selector.dart';
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flapp/interval.dart';

class GradingScaleMenu extends StatefulWidget {
  final GradingScale gradingScale;

  const GradingScaleMenu({Key? key, required this.gradingScale}) : super(key: key);

  @override
  _GradingScaleMenuState createState() => _GradingScaleMenuState();
}

class _GradingScaleMenuState extends State<GradingScaleMenu> {
  late List<Interval> _intervals;

  @override
  void initState() {
    _intervals = [...widget.gradingScale.scale];
    super.initState();
  }

  double getBelow(int index) {
    if (index == _intervals.length - 1) {
      return 0;
    }

    return _intervals[index + 1].lower;
  }

  double getAbove(int index) {
    if (index == 0) {
      return 100;
    }

    return _intervals[index - 1].upper;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text("Save"),
          onPressed: () {
            context.read<Grader>().gradingScale = GradingScale(scale: _intervals);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Restore default"),
          onPressed: () {
            context.read<Grader>().gradingScale = GradingScale.collegeBoard();
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...List.generate(
              _intervals.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => GradingScaleSelector(
                              interval: _intervals[index],
                              min: getBelow(index),
                              max: getAbove(index),
                              onIntervalChange: (rV) {
                                setState(() {
                                  _intervals[index].lower = rV.start;
                                  _intervals[index].upper = rV.end;
                                  if (index > 0) {
                                    _intervals[index - 1].lower = rV.end;
                                  }

                                  if (index < _intervals.length - 1) {
                                    _intervals[index + 1].upper = rV.start;
                                  }
                                });
                              },
                              onLetterGradeChange: (val) {
                                setState(() {
                                  _intervals[index].letterGrade = val;
                                });
                              },
                              onRemove: _intervals.length >= 2
                                  ? () {
                                      setState(() {
                                        if (index == 0) {
                                          _intervals[1].upper = 100;
                                        } else if (index == _intervals.length - 1) {
                                          _intervals[_intervals.length - 2].lower = 0;
                                        } else {
                                          double midpoint =
                                              (((_intervals[index].upper + _intervals[index].lower) / 2) * 10)
                                                      .roundToDouble() /
                                                  10;
                                          _intervals[index - 1].lower = midpoint;
                                          _intervals[index + 1].upper = midpoint;
                                        }
                                        _intervals.removeAt(index);
                                      });
                                    }
                                  : null,
                              onAdd: (above) {
                                setState(() {
                                  double midpoint =
                                      (((_intervals[index].upper + _intervals[index].lower) / 2) * 10).roundToDouble() /
                                          10;
                                  if (above) {
                                    double upper = _intervals[index].upper;
                                    _intervals[index].upper = midpoint;
                                    _intervals.insert(index, Interval("X", midpoint, upper));
                                  } else {
                                    double lower = _intervals[index].lower;
                                    _intervals[index].lower = midpoint;
                                    _intervals.insert(index + 1, Interval("X", lower, midpoint));
                                  }
                                });
                              },
                            ));
                  },
                  child: AbsorbPointer(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Text(_intervals[index].letterGrade),
                          ),
                          const Spacer(),
                          Text(
                            "${_intervals[index].lower} - ${_intervals[index].upper}",
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
