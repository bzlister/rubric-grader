import 'dart:collection';
import 'dart:math';
import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/cupertino.dart';
import 'package:tuple/tuple.dart';
import 'package:xid/xid.dart';

class GradedAssignment extends ChangeNotifier {
  final HashMap<Xid, Xid> _scoreSelections;
  int _daysLate;
  Rubric _rubric;
  String? _comment;
  String? _name;
  Xid xid;

  GradedAssignment(
    this._rubric,
    this._scoreSelections,
    this._daysLate,
    this._comment,
    this._name,
  ) : xid = Xid();

  GradedAssignment.empty(this._rubric)
      : _scoreSelections = HashMap<Xid, Xid>(),
        _daysLate = 0,
        xid = Xid();

  set rubric(Rubric newRubric) {
    _rubric = newRubric;
    notifyListeners();
  }

  int get daysLate => _daysLate;

  set daysLate(int numDays) {
    _daysLate = numDays;
    notifyListeners();
  }

  double get earnedPoints {
    double points = 0;
    for (MapEntry<Xid, Xid> entry in _scoreSelections.entries) {
      Category? category = _rubric.getCategoryByXid(entry.key);
      double? score = _rubric.getScoreByXid(entry.value);
      if (category != null && score != null) {
        points += category.weight * score * 0.01;
      }
    }
    return points;
  }

  void select(int rowNum, int colNum) {
    _scoreSelections[_rubric.categories[rowNum].xid] =
        _rubric.scoreBins[colNum].xid;
    notifyListeners();
  }

  void deselect(int rowNum) {
    _scoreSelections.remove(_rubric.categories[rowNum].xid);
    notifyListeners();
  }

  int getSelection(int rowNum) {
    Xid? selected = _scoreSelections[_rubric.categories[rowNum].xid];
    if (selected != null) {
      return _rubric.scoreBins.indexWhere((val) => val.xid == selected);
    }
    return -1;
  }

  double get latePenalty {
    double percentageOff = _daysLate * _rubric.latePercentagePerDay * 0.01;
    return min(
      percentageOff *
          (_rubric.latePolicy == "total" ? _rubric.totalPoints : earnedPoints),
      earnedPoints,
    );
  }

  Tuple2<String, double> calcGrade(GradingScale gradingScale) {
    double total = _rubric.totalPoints;
    if (total == 0) {
      return const Tuple2("", 0);
    }
    double finalScore = (earnedPoints - latePenalty) / total * 100;
    String label = gradingScale.scale[0].item1;
    for (int i = 0; i < gradingScale.scale.length; i++) {
      if (gradingScale.scale[i].item2 <= finalScore) {
        label = gradingScale.scale[i].item1;
        break;
      }
    }
    return Tuple2(label, finalScore);
  }

  String? get comment => _comment;

  set comment(String? newComment) {
    _comment = newComment;
    notifyListeners();
  }
}
