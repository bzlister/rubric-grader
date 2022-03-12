import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flutter/cupertino.dart';
import 'package:xid/xid.dart';

class Rubric extends ChangeNotifier {
  String? _assignmentName;
  List<ScoreBin> _scoreBins;
  List<Category> _categories;
  String _latePolicy;
  double _latePercentagePerDay;
  List<GradedAssignment> _gradedAssignments;
  Xid xid;
  String _defaultStudentName = "Student 1";

  Rubric(this._assignmentName, this._scoreBins, this._categories, this._latePolicy, this._latePercentagePerDay,
      this._gradedAssignments, this.xid);

  Rubric.empty()
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
        _gradedAssignments = [],
        _assignmentName = null,
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

  void reset() {
    Rubric newRubric = Rubric.empty();
    _assignmentName = newRubric._assignmentName;
    _scoreBins = newRubric._scoreBins;
    _categories = newRubric._categories;
    _latePolicy = newRubric._latePolicy;
    _latePercentagePerDay = newRubric._latePercentagePerDay;
    _gradedAssignments = newRubric._gradedAssignments;
    xid = newRubric.xid;
    notifyListeners();
  }

  void load(Rubric toLoad) {
    _assignmentName = toLoad._assignmentName;
    _scoreBins = toLoad._scoreBins;
    _categories = toLoad._categories;
    _latePolicy = toLoad._latePolicy;
    _latePercentagePerDay = toLoad._latePercentagePerDay;
    _gradedAssignments = toLoad._gradedAssignments;
    xid = toLoad.xid;
    notifyListeners();
  }

  List<GradedAssignment> get gradedAssignments => _gradedAssignments;

  void saveGradedAssignment(GradedAssignment gradedAssignment) {
    int indx = -1;
    for (var i = 0; i < _gradedAssignments.length; i++) {
      if (_gradedAssignments[i].xid == gradedAssignment.xid) {
        indx = i;
        break;
      }
    }

    GradedAssignment copy = gradedAssignment.copy();
    copy.xid = gradedAssignment.xid;
    if (indx != -1) {
      _gradedAssignments[indx] = copy;
    } else {
      _gradedAssignments.add(copy);
    }
    _calcDefaultStudentName();
    notifyListeners();
  }

  void deleteGradedAssignments(List<Xid> xids) {
    _gradedAssignments = [..._gradedAssignments.where((ga) => xids.contains(ga.xid) == false)];
    _calcDefaultStudentName();
    notifyListeners();
  }

  String get defaultStudentName => _defaultStudentName;

  void _calcDefaultStudentName() {
    try {
      List<String> matches = [];
      for (var i = 0; i < _gradedAssignments.length; i++) {
        if (RegExp(r"^Student \d+$").hasMatch(_gradedAssignments[i].name!)) {
          matches.add(_gradedAssignments[i].name!);
        }
      }

      int greatest = 0;
      for (var j = 0; j < matches.length; j++) {
        int defaultStudentNum = int.parse(matches[j].substring(matches[j].indexOf(" ")));
        if (defaultStudentNum > greatest) {
          greatest = defaultStudentNum;
        }
      }
      _defaultStudentName = 'Student ${greatest + 1}';
    } catch (exception) {
      _defaultStudentName = "Student 1";
    }
  }

  GradedAssignment? findGradedAssignmentByXid(Xid xid) {
    try {
      return _gradedAssignments.firstWhere((element) => element.xid == xid);
    } on StateError {
      return null;
    }
  }

  String? get assignmentName => _assignmentName;

  set assignmentName(String? name) {
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
    return '$_assignmentName;$fromScores;$fromCategories;$_latePolicy;$_latePercentagePerDay';
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
