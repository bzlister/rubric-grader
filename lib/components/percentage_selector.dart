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
  late List<Color> _colors;
  late int? _sectionIndexA;
  late int? _sectionIndexB;
  late double? _fixedAngleA;
  late double? _fixedAngleB;
  late double? _angleOffset;

  @override
  void initState() {
    super.initState();
    _categories = widget.categories;
    _colors = List.generate(_categories.length, (index) => Colors.grey);
    _angleOffset = 0;
  }

  void _calcBoundaries(int indx, double touchAngle) {
    List<List<double>> allAngles = [
      [0, _categories[0].weight * 360]
    ];
    for (int i = 1; i < _categories.length; i++) {
      List<double> prev = allAngles[i - 1];
      allAngles.add([prev[1], prev[1] + _categories[i].weight * 360]);
    }
    double midpoint = (allAngles[indx][0] + allAngles[indx][1]) / 2;
    setState(() {
      _sectionIndexA = indx;
      if (touchAngle <= midpoint) {
        _sectionIndexB = (indx - 1) % _categories.length;
        _fixedAngleA = allAngles[indx][1] % 360.0;
        _fixedAngleB = allAngles[_sectionIndexB!][0] % 360.0;
      } else {
        _sectionIndexB = (indx + 1) % _categories.length;
        _fixedAngleA = allAngles[indx][0] % 360.0;
        _fixedAngleB = allAngles[_sectionIndexB!][1] % 360.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pieChartSectionData = _categories.map((c) {
      int indxx = _categories.indexOf(c);
      return PieChartSectionData(
          radius: 110, value: c.weight, color: _colors[indxx], title: c.label);
    }).toList();
    return PieChart(
      PieChartData(
          sections: pieChartSectionData,
          centerSpaceRadius: 0,
          startDegreeOffset: _angleOffset,
          pieTouchData:
              PieTouchData(touchCallback: (touchEvent, pieTouchResponse) {
            PieTouchedSection? touchedSection =
                pieTouchResponse?.touchedSection;
            if (touchedSection != null) {
              if (touchEvent is FlLongPressStart) {
                setState(() {
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
                  setState(() {
                    _colors[_sectionIndexA!] = Colors.red;
                    _colors[_sectionIndexB!] = Colors.blue;
                    double newAngleA =
                        (touchedSection.touchAngle - _fixedAngleA!).abs();
                    double newAngleB =
                        (touchedSection.touchAngle - _fixedAngleB!).abs();
                    _categories[_sectionIndexA!].weight = newAngleA / 360;
                    _categories[_sectionIndexB!].weight = newAngleB / 360;
                    if (_sectionIndexA == 0 &&
                        _sectionIndexB == _categories.length - 1) {
                      _angleOffset = touchedSection.touchAngle;
                    } else if (_sectionIndexA == _categories.length - 1 &&
                        _sectionIndexB == 0) {
                      _angleOffset = touchedSection.touchAngle;
                    }
                  });
                }
              } else if (touchEvent is FlLongPressEnd) {
                _colors =
                    List.generate(_categories.length, (index) => Colors.grey);

                _fixedAngleA = null;
                _fixedAngleB = null;
                _sectionIndexA = null;
                _sectionIndexB = null;
                print(
                    "END\n\tSection: ${touchedSection.touchedSection?.title}\n\tAngle:${touchedSection.touchAngle}\n\tRadius:${touchedSection.touchRadius}");
              }
            }
          })),
    );
  }
}
