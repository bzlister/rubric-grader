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
  String? _comment;
  String? _name;
  Xid xid;

  GradedAssignment(
    this._scoreSelections,
    this._daysLate,
    this._comment,
    this._name,
  ) : xid = Xid();

  GradedAssignment.empty()
      : _scoreSelections = HashMap<Xid, Xid>(),
        _daysLate = 0,
        xid = Xid();

  int get daysLate => _daysLate;

  set daysLate(int numDays) {
    _daysLate = numDays;
    notifyListeners();
  }

/*
  void select(int rowNum, int colNum) {
    _scoreSelections[_rubric.categories[rowNum].xid] =
        _rubric.scoreBins[colNum].xid;
    notifyListeners();
  }
*/
  void select(Xid row, Xid col) {
    _scoreSelections[row] = col;
    notifyListeners();
  }

/*
  void deselect(int rowNum) {
    _scoreSelections.remove(_rubric.categories[rowNum].xid);
    notifyListeners();
  }
*/

  void deselect(Xid row) {
    _scoreSelections.remove(row);
    notifyListeners();
  }

  Xid? getSelection(Xid xid) => _scoreSelections[xid];

  HashMap<Xid, Xid> get selections => _scoreSelections;

/*
  int getSelection(int rowNum) {
    Xid? selected = _scoreSelections[_rubric.categories[rowNum].xid];
    if (selected != null) {
      return _rubric.scoreBins.indexWhere((val) => val.xid == selected);
    }
    return -1;
  }
*/

  String? get comment => _comment;

  set comment(String? newComment) {
    _comment = newComment;
    notifyListeners();
  }
}
