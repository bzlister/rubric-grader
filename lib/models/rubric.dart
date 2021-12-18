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
          Factor("A", 1.0),
          Factor("B", 0.85),
          Factor("C", 0.75),
          Factor("D", 0.7),
          Factor("F", 0.6)
        ],
        _categories = [
          Factor("Audience & Genre", 0.3),
          Factor("Thesis & Support", 0.3),
          Factor("Reasoning", 0.2),
          Factor("Organization & Style", 0.15),
          Factor("Correctness", 0.05)
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

  void updateGrade(int index, Factor value) {
    _grades[index] = value;
    notifyListeners();
  }

  UnmodifiableListView<Factor> get categories =>
      UnmodifiableListView(_categories);

  void updateCategory(int index, Factor value) {
    _categories[index] = value;
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
