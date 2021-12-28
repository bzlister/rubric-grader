import 'dart:collection';
import 'package:tuple/tuple.dart';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  double _totalPoints;
  String _assignmentName;
  List<FactorContainer> _grades;
  List<FactorContainer> _categories;

  Rubric(
    this._assignmentName,
    this._grades,
    this._categories,
  ) : _totalPoints = _categories
            .map((c) => c.data.weight)
            .reduce((value, element) => value + element);

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
        _totalPoints = 200;

  double get totalPoints => _totalPoints;

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

  bool isCategoryLabelUsed(String label) {
    return _categories.any((element) => element.data.label == label);
  }
}

class FactorContainer {
  Factor _data;
  UniqueKey id;

  FactorContainer({required String label, required double weight})
      : id = UniqueKey(),
        _data = Factor(label, weight);

  Factor get data => _data;

  void update(String newLabel, double newWeight) {
    _data = Factor(newLabel, newWeight);
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
