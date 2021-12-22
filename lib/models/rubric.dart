import 'dart:collection';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  int _totalPoints;
  String _assignmentName;
  final List<Factor> _grades;
  final List<Factor> _categories;

  Rubric(
    this._totalPoints,
    this._assignmentName,
    this._grades,
    this._categories,
  );

  Rubric.standard()
      : _totalPoints = 200,
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

  int get totalPoints => _totalPoints;

  void setTotalPoints(int value) {
    _totalPoints = value;
    notifyListeners();
  }

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  UnmodifiableListView<Factor> get grades => UnmodifiableListView(_grades);

  void updateGrade(String label, Factor newGrade) {
    Factor oldGrade = _grades.firstWhere((element) => element.label == label);
    oldGrade.label = newGrade.label;
    oldGrade.weight = newGrade.weight;
    notifyListeners();
  }

  UnmodifiableListView<Factor> get categories =>
      UnmodifiableListView(_categories);

  void updateCategory(String label, Factor newCategory) {
    Factor oldCategory =
        _categories.firstWhere((element) => element.label == label);
    oldCategory.label = newCategory.label;
    oldCategory.weight = newCategory.weight;
    notifyListeners();
  }

  void addCategory() {
    _categories.add(Factor("", 0));
    notifyListeners();
  }

  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }
}

class Factor {
  String label;
  double weight;

  Factor(this.label, this.weight);
}
