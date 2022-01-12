import 'dart:collection';
import 'dart:math';
import 'package:tuple/tuple.dart';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  String _assignmentName;
  List<FactorContainer> _grades;
  List<FactorContainer> _categories;
  String _latePolicy;
  int _daysLate;
  double _latePercentagePerDay;

  Rubric(
    this._assignmentName,
    this._grades,
    this._categories,
    this._latePolicy,
    this._daysLate,
    this._latePercentagePerDay,
  );

  Rubric.standard()
      : _assignmentName = "Assignment 1",
        _grades = [
          FactorContainer(label: "A", weight: 100),
          FactorContainer(label: "B", weight: 85),
          FactorContainer(label: "C", weight: 75),
          FactorContainer(label: "D", weight: 70),
          FactorContainer(label: "F", weight: 60)
        ],
        _categories = [
          FactorContainer(label: "Audience & Genre", weight: 60),
          FactorContainer(label: "Thesis & Support", weight: 60),
          FactorContainer(label: "Reasoning", weight: 40),
          FactorContainer(label: "Organization & Style", weight: 30),
          FactorContainer(label: "Correctness", weight: 10)
        ],
        _latePolicy = "total",
        _daysLate = 0,
        _latePercentagePerDay = 20;

  double get totalPoints => _categories
      .map((c) => c.data.weight)
      .reduce((value, element) => value + element);

  double get earnedPoints {
    double points = 0;
    for (int i = 0; i < _categories.length; i++) {
      int indx = getSelection(i);
      if (indx != -1) {
        points += _categories[i].data.weight * _grades[indx].data.weight * 0.01;
      }
    }
    return points;
  }

  int getSelection(int categoryIndex) {
    if (_categories[categoryIndex].selected != null) {
      return _grades.indexWhere(
          (grade) => grade.id == _categories[categoryIndex].selected);
    }
    return -1;
  }

  void makeSelection(int categoryIndex, int rowIndex) {
    _categories[categoryIndex].selected = _grades[rowIndex].id;
    notifyListeners();
  }

  void cancelSelection(int categoryIndex, int rowIndex) {
    _categories[categoryIndex].selected = null;
    notifyListeners();
  }

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  List<Factor> get grades => _grades.map((grade) => grade.data).toList();

  Factor getGrade(int index) => _grades[index].data;

  void updateGrade(int index, String newLabel, double newWeight) {
    _grades = [..._grades];
    _grades[index].update(newLabel, newWeight);
    notifyListeners();
  }

  List<Factor> get categories =>
      _categories.map((category) => category.data).toList();

  Factor getCategory(int index) => _categories[index].data;

  void updateCategory(int index, String newLabel, double newWeight) {
    _categories = [..._categories];
    _categories[index].update(newLabel, newWeight);
    notifyListeners();
  }

  void addCategory(String label, double weight) {
    _categories.add(FactorContainer(label: label, weight: weight));
    notifyListeners();
  }

  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  bool isCategoryLabelUsed(int index, String label) {
    bool retval = false;
    for (int i = 0; i < _categories.length; i++) {
      if (_categories[i].data.label == label && i != index) {
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

  int get daysLate => _daysLate;

  int maxDaysLate() => (100.0 / latePercentagePerDay).ceil();

  set daysLate(int numDays) {
    _daysLate = numDays;
    notifyListeners();
  }

  double get latePercentagePerDay => _latePercentagePerDay;

  set latePercentagePerDay(double percentage) {
    _latePercentagePerDay = percentage;
    notifyListeners();
  }

  double get latePenalty {
    double percentageOff = daysLate * latePercentagePerDay * 0.01;
    return min(
        percentageOff * (latePolicy == "total" ? totalPoints : earnedPoints),
        earnedPoints);
  }
}

class FactorContainer {
  Factor _data;
  UniqueKey id;
  UniqueKey? selected;

  FactorContainer({required String label, required double weight})
      : id = UniqueKey(),
        _data = Factor(label, weight);

  Factor get data => _data;

  void update(String newLabel, double newWeight) {
    _data = Factor(newLabel, newWeight);
  }

  void select(UniqueKey selectedId) {
    selected = selectedId;
  }

  @override
  bool operator ==(Object other) {
    if (other is FactorContainer) {
      return other.data.label == _data.label &&
          other.data.weight == _data.weight;
    }
    return false;
  }

  @override
  int get hashCode {
    return "${_data.label}_${_data.weight}".hashCode;
  }
}

class Factor extends Tuple2<String, double> {
  Factor(String label, double weight) : super(label, weight);

  get label => item1;
  get weight => item2;
}
