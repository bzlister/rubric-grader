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
  late int? _sectionIndexA;
  late int? _sectionIndexB;
  late double? _fixedAngleA;
  late double? _fixedAngleB;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
  }

  void _calcBoundaries(int indx, double touchAngle) {
    List<List<double>> allAngles = [
      [0, _categories[0].weight * 3.6]
    ];
    for (int i = 1; i < _categories.length; i++) {
      List<double> prev = allAngles[i - 1];
      allAngles.add([prev[1], prev[1] + _categories[i].weight * 3.6]);
    }
    double midpoint = (allAngles[indx][0] + allAngles[indx][1]) / 2;
    setState(() {
      _sectionIndexA = indx;
      if (touchAngle <= midpoint) {
        _sectionIndexB = (indx - 1) % _categories.length;
        _fixedAngleA = allAngles[indx][1];
        _fixedAngleB = allAngles[_sectionIndexB!][0];
      } else {
        _sectionIndexB = (indx + 1) % _categories.length;
        _fixedAngleA = allAngles[indx][0];
        _fixedAngleB = allAngles[_sectionIndexB!][1];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pieChartSectionData = _categories
        .map((c) => PieChartSectionData(
            radius: 110,
            value: c.weight,
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            title: c.label))
        .toList();
    return PieChart(
      PieChartData(
          sections: pieChartSectionData,
          centerSpaceRadius: 0,
          pieTouchData:
              PieTouchData(touchCallback: (touchEvent, pieTouchResponse) {
            PieTouchedSection? touchedSection =
                pieTouchResponse?.touchedSection;
            if (touchedSection != null) {
              if (touchEvent is FlLongPressStart) {
                setState(() {
                  //_currSectionIndex = touchedSection.touchedSectionIndex;
                  _calcBoundaries(
                    touchedSection.touchedSectionIndex,
                    touchedSection.touchAngle,
                  );
                  print(
                      "Section A: ${_categories[_sectionIndexA!].label}, Fixed angle: $_fixedAngleA");
                  print(
                      "Section B: ${_categories[_sectionIndexB!].label}, Fixed angle: $_fixedAngleB");
                });
              } else if (touchEvent is FlLongPressMoveUpdate) {
                if (_fixedAngleA != null &&
                    _fixedAngleB != null &&
                    _sectionIndexA != null &&
                    _sectionIndexB != null) {
                  //setState(() {});
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
