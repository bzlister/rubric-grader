import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:xid/xid.dart';

class Rubric extends ChangeNotifier {
  String _assignmentName;
  List<ScoreBin> _scoreBins;
  List<Category> _categories;
  String _latePolicy;
  double _latePercentagePerDay;
  List<GradedAssignment> _gradedAssignments;
  GradedAssignment? _currentGradedAssignment;
  Xid xid;

  Rubric(
    this._assignmentName,
    this._scoreBins,
    this._categories,
    this._latePolicy,
    this._latePercentagePerDay,
    this._gradedAssignments,
    this._currentGradedAssignment,
  ) : xid = Xid();

  Rubric.empty(this._assignmentName)
      : _scoreBins = [
          ScoreBin(100),
          ScoreBin(90),
          ScoreBin(80),
          ScoreBin(70),
          ScoreBin(60),
        ],
        _categories = [],
        _latePolicy = "total",
        _latePercentagePerDay = 20,
        _gradedAssignments = [GradedAssignment(HashMap<Xid, Xid>(), 0, "Bad", "Bad student")],
        xid = Xid();

  Rubric.example()
      : _assignmentName = "Assignment 1",
        _scoreBins = [
          ScoreBin(100),
          ScoreBin(90),
          ScoreBin(80),
          ScoreBin(70),
          ScoreBin(60),
        ],
        _categories = [
          Category(60, "Audience & Genre"),
          Category(60, "Thesis & Support"),
          Category(40, "Reasoning"),
          Category(30, "Organization & Style"),
          Category(10, "Correctness"),
        ],
        _latePolicy = "total",
        _latePercentagePerDay = 20,
        _gradedAssignments = [],
        xid = Xid();

  set currentGradedAssignment(GradedAssignment? gradedAssignment) {
    _currentGradedAssignment = gradedAssignment;
    notifyListeners();
  }

  GradedAssignment? get currentGradedAssignment => _currentGradedAssignment;

  List<GradedAssignment> get gradedAssignments => _gradedAssignments;

  String get assignmentName => _assignmentName;

  set assignmentName(String name) {
    _assignmentName = name;
    notifyListeners();
  }

  double get totalPoints => _categories.map((c) => c.weight).sum;

  List<ScoreBin> get scoreBins => _scoreBins;

  double getScore(int index) => _scoreBins[index].weight;

  double? getScoreByXid(Xid xid) => _scoreBins.singleWhereOrNull((scoreBin) => scoreBin.xid == xid)?.weight;

  int? getScoreIndexByXid(Xid xid) {
    for (var i = 0; i < _scoreBins.length; i++) {
      if (_scoreBins[i].xid == xid) {
        return i;
      }
    }
    return null;
  }

  void updateScore(int index, double newWeight) {
    _scoreBins = [..._scoreBins];
    _scoreBins[index] = ScoreBin.update(newWeight, _scoreBins[index].xid);
    notifyListeners();
  }

  List<Category> get categories => _categories;

  Category getCategory(int index) => _categories[index];

  Category? getCategoryByXid(Xid xid) => _categories.singleWhereOrNull((category) => category.xid == xid);

  void updateCategory(int index, String newLabel, double newWeight) {
    _categories = [..._categories];
    _categories[index] = Category.update(newWeight, newLabel, _categories[index].xid);
    notifyListeners();
  }

  void addCategory(String label, double weight) {
    _categories.add(Category(weight, label));
    notifyListeners();
  }

  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  bool isCategoryLabelUsed(int index, String label) {
    bool retval = false;
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].label == label && i != index) {
        retval = true;
        break;
      }
    }
    return retval;
  }

  String get latePolicy => _latePolicy;

  set latePolicy(String newPolicy) {
    _latePolicy = newPolicy;
    notifyListeners();
  }

  int maxDaysLate() => (100.0 / latePercentagePerDay).ceil();

  double get latePercentagePerDay => _latePercentagePerDay;

  set latePercentagePerDay(double percentage) {
    _latePercentagePerDay = percentage;
    notifyListeners();
  }

  String getState() {
    String fromScores = _scoreBins.isNotEmpty
        ? _scoreBins.map((scoreBin) => '${scoreBin._weight}').reduce((value, element) => '$value,$element')
        : "";
    String fromCategories = _categories.isNotEmpty
        ? _categories
            .map((category) => '${category.label}:${category.weight}')
            .reduce((value, element) => '$value,$element')
        : "";
    return '$_assignmentName;$fromScores;$fromCategories;$_latePolicy;$_latePercentagePerDay;${_currentGradedAssignment?.getState()}';
  }
}

class ScoreBin {
  final double _weight;
  final Xid xid;

  ScoreBin(this._weight) : xid = Xid();

  ScoreBin.update(this._weight, this.xid);

  double get weight => _weight;
}

class Category extends ScoreBin {
  final String _label;

  Category(double _weight, this._label) : super(_weight);

  Category.update(double _weight, this._label, Xid xid) : super.update(_weight, xid);

  String get label => _label;
}
