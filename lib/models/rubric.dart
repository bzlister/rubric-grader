import 'dart:collection';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  Factor _totalPoints;
  String _assignmentName;
  List<Factor> _grades;
  List<Factor> _categories;

  Rubric(
    this._totalPoints,
    this._assignmentName,
    this._grades,
    this._categories,
  );

  Rubric.standard()
      : _totalPoints = Factor("Total points", 200),
        _assignmentName = "Assignment 1",
        _grades = [
          Factor("A", 100),
          Factor("B", 85),
          Factor("C", 75),
          Factor("D", 70),
          Factor("F", 60)
        ],
        _categories = [
          Factor("Audience & Genre", 30),
          Factor("Thesis & Support", 30),
          Factor("Reasoning", 20),
          Factor("Organization & Style", 15),
          Factor("Correctness", 5)
        ];

  Factor get totalPoints => _totalPoints;

  void setTotalPoints(double value) {
    _totalPoints.weight = value;
    notifyListeners();
  }

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  UnmodifiableListView<Factor> get grades => UnmodifiableListView(_grades);

  void updateGrade(int index, Factor newGrade) {
    _grades[index] = Factor(newGrade.label, newGrade.weight);
    List<Factor> newGrades = [];
    for (var grade in _grades) {
      newGrades.add(grade);
    }
    _grades = newGrades;
    notifyListeners();
  }

  UnmodifiableListView<Factor> get categories =>
      UnmodifiableListView(_categories);

  void updateCategory(int index, Factor newCategory) {
    _categories[index] = Factor(newCategory.label, newCategory.weight);
    List<Factor> newCategories = [];
    for (var category in _categories) {
      newCategories.add(category);
    }
    _categories = newCategories;
    notifyListeners();
  }

  void addCategory(Factor category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  bool isCategoryLabelUsed(String label) {
    return _categories.any((element) => element.label == label);
  }
}

class Factor {
  String label;
  double weight;

  Factor(this.label, this.weight);

  @override
  bool operator ==(Object other) {
    if (other is Factor) {
      return other.label == label && other.weight == weight;
    }
    return false;
  }

  @override
  int get hashCode {
    return "${label}_$weight".hashCode;
  }
}
