import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:xid/xid.dart';

class GradedAssignment extends ChangeNotifier {
  HashMap<Xid, Xid> _scoreSelections;
  int _daysLate;
  String? _comment;
  String _name;
  Xid _xid;

  GradedAssignment(
    this._scoreSelections,
    this._daysLate,
    this._comment,
    this._name,
  ) : _xid = Xid();

  GradedAssignment.empty(this._name)
      : _scoreSelections = HashMap<Xid, Xid>(),
        _daysLate = 0,
        _xid = Xid();

  GradedAssignment copy() {
    return GradedAssignment(HashMap<Xid, Xid>.from({..._scoreSelections}), _daysLate, _comment, _name);
  }

  void load(GradedAssignment toLoad) {
    _scoreSelections = toLoad._scoreSelections;
    _daysLate = toLoad._daysLate;
    _comment = toLoad._comment;
    _name = toLoad._name;
    _xid = toLoad._xid;
    notifyListeners();
  }

  void reset(String defaultStudentName) {
    GradedAssignment newGradedAssignment = GradedAssignment.empty(defaultStudentName);
    _scoreSelections = newGradedAssignment.selections;
    _daysLate = newGradedAssignment._daysLate;
    _comment = newGradedAssignment._comment;
    _name = newGradedAssignment._name;
    _xid = newGradedAssignment._xid;
    notifyListeners();
  }

  Xid get xid => _xid;

  set xid(Xid newValue) {
    _xid = newValue;
    notifyListeners();
  }

  int get daysLate => _daysLate;

  set daysLate(int numDays) {
    _daysLate = numDays;
    notifyListeners();
  }

  void select(Xid row, Xid col) {
    _scoreSelections[row] = col;
    notifyListeners();
  }

  void deselect(Xid row) {
    _scoreSelections.remove(row);
    notifyListeners();
  }

  Xid? getSelection(Xid xid) => _scoreSelections[xid];

  HashMap<Xid, Xid> get selections => _scoreSelections;

  String? get comment => _comment;

  set comment(String? newComment) {
    _comment = newComment;
    notifyListeners();
  }

  String get name => _name;

  set name(String newName) {
    _name = newName;
    notifyListeners();
  }

  String getState() {
    String fromSelections = _scoreSelections.isNotEmpty
        ? _scoreSelections.entries
            .map((entry) => '${entry.key.hashCode}:${entry.value.hashCode}')
            .reduce((value, element) => '$value,$element')
        : "";

    return '$fromSelections;$_daysLate;$_comment;$_name';
  }
}
