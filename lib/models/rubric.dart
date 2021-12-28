import 'dart:collection';
import 'package:tuple/tuple.dart';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  double _totalPoints;
  String _assignmentName;
  List<Factor> _grades;
  List<Factor> _categories;

  Rubric(
    this._assignmentName,
    this._grades,
    this._categories,
  ) : _totalPoints = _categories
            .map((c) => c.weight)
            .reduce((value, element) => value + element);

  Rubric.standard()
      : _assignmentName = "Assignment 1",
        _grades = [
          Factor(label: "A", weight: 100),
          Factor(label: "B", weight: 85),
          Factor(label: "C", weight: 75),
          Factor(label: "D", weight: 70),
          Factor(label: "F", weight: 60)
        ],
        _categories = [
          Factor(label: "Audience & Genre", weight: 60),
          Factor(label: "Thesis & Support", weight: 60),
          Factor(label: "Reasoning", weight: 40),
          Factor(label: "Organization & Style", weight: 30),
          Factor(label: "Correctness", weight: 10)
        ],
        _totalPoints = 200;

  double get totalPoints => _totalPoints;

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  List<Tuple2<String, double>> get grades =>
      _grades.map((grade) => grade.data).toList();

  Tuple2<String, double> getGrade(int index) => _grades[index].data;

  void updateGrade(int index, String newLabel, double newWeight) {
    //_grades[index] = Factor.from(newGrade, _grades[index].id);
    _grades = [..._grades];
    _grades[index].label = newLabel;
    _grades[index].weight = newWeight;
    /*
    List<Factor> newGrades = [];
    for (var grade in _grades) {
      newGrades.add(grade);
    }
    _grades = newGrades;
    */
    notifyListeners();
  }

  List<Tuple2<String, double>> get categories =>
      _categories.map((category) => category.data).toList();

  Tuple2<String, double> getCategory(int index) => _categories[index].data;

  void updateCategory(int index, String newLabel, double newWeight) {
    //_categories[index] = Factor.from(newCategory, _categories[index].id);
    _categories = [..._categories];
    _categories[index].label = newLabel;
    _categories[index].weight = newWeight;
    /*
    List<Factor> newCategories = [];
    double newPoints = 0;
    for (var category in _categories) {
      newCategories.add(category);
      newPoints += category.weight;
    }
    _categories = newCategories;
    _totalPoints = newPoints;
    */
    notifyListeners();
  }

  void addCategory(String label, double weight) {
    _categories.add(Factor(label: label, weight: weight));
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
  UniqueKey id;

  Factor({required this.label, required this.weight}) : id = UniqueKey();

  Tuple2<String, double> get data => Tuple2<String, double>(label, weight);

  Factor.from(Factor f, this.id)
      : label = f.label,
        weight = f.weight;

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
