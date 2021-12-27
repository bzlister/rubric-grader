import 'package:fl_chart/fl_chart.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PercentageSelector extends StatefulWidget {
  final List<Factor> categories;

  const PercentageSelector({Key? key, required this.categories})
      : super(key: key);

  @override
  _PercentageSelectorState createState() => _PercentageSelectorState();
}

class _PercentageSelectorState extends State<PercentageSelector> {
  late List<Factor> _categories;
  late int _currSectionIndex;
  late double _initAngle;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
  }

  double calcStartAngle(int index) {
    double startAngle = 0;
    for (int i = 0; i < index; i++) {
      startAngle += _categories[index].weight * 3.6;
    }
    return startAngle;
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
          sections: _categories
              .map((c) => PieChartSectionData(
                  radius: 110,
                  value: c.weight,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  title: c.label))
              .toList(),
          centerSpaceRadius: 0,
          pieTouchData:
              PieTouchData(touchCallback: (touchEvent, pieTouchResponse) {
            PieTouchedSection? touchedSection =
                pieTouchResponse?.touchedSection;
            if (touchedSection != null) {
              if (touchEvent is FlLongPressStart) {
                setState(() {
                  _currSectionIndex = touchedSection.touchedSectionIndex;
                  _initAngle = touchedSection.touchAngle;
                });
              } else if (touchEvent is FlLongPressMoveUpdate) {
                if (_currSectionIndex != null && _initAngle != null) {
                  setState(() {
                    double newWeight = (touchedSection.touchAngle -
                                calcStartAngle(_currSectionIndex))
                            .abs() /
                        360.0;
                    double newWeightNextSection =
                        (_categories[_currSectionIndex].weight - newWeight) +
                            _categories[(_currSectionIndex + 1) %
                                    _categories.length]
                                .weight;

                    print(
                        "Assigning $newWeight to ${_categories[_currSectionIndex].label}");
                    print(
                        "Assigning $newWeightNextSection to ${_categories[(_currSectionIndex + 1) % _categories.length].label}");
                    _categories[_currSectionIndex].weight = newWeight;
                    _categories[_currSectionIndex].weight =
                        newWeightNextSection;
                  });
                }
              } else if (touchEvent is FlLongPressEnd) {
                print(
                    "END\n\tSection: ${touchedSection.touchedSection?.title}\n\tAngle:${touchedSection.touchAngle}\n\tRadius:${touchedSection.touchRadius}");
              }
            }
          })),
    );
  }
}
