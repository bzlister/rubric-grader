import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  String _assignmentName;
  List<SemanticValue> _scoreBins;
  List<Category> categories;
  String _latePolicy;
  double _latePercentagePerDay;
  String _comment;

  Rubric(
    this._assignmentName,
    this._scoreBins,
    this.categories,
    this._latePolicy,
    this._latePercentagePerDay,
    this._comment,
  );

  Rubric.empty()
      : _assignmentName = "Assignment 1",
        _scoreBins = [
          SemanticValue(weight: 100),
          SemanticValue(weight: 85),
          SemanticValue(weight: 75),
          SemanticValue(weight: 70),
          SemanticValue(weight: 60),
        ],
        categories = [],
        _latePolicy = "total",
        _latePercentagePerDay = 20,
        _comment = "";

  Rubric.example()
      : _assignmentName = "Assignment 1",
        _scoreBins = [
          SemanticValue(weight: 100),
          SemanticValue(weight: 85),
          SemanticValue(weight: 75),
          SemanticValue(weight: 70),
          SemanticValue(weight: 60),
        ],
        categories = [
          Category(label: "Audience & Genre", weight: 60),
          Category(label: "Thesis & Support", weight: 60),
          Category(label: "Reasoning", weight: 40),
          Category(label: "Organization & Style", weight: 30),
          Category(label: "Correctness", weight: 10)
        ],
        _latePolicy = "total",
        _latePercentagePerDay = 20,
        _comment = "";

  String get assignmentName => _assignmentName;

  set assignmentName(String name) {
    _assignmentName = name;
    notifyListeners();
  }

  double get totalPoints => categories.map((c) => c.weight).sum;

  List<SemanticValue> get scoreBins => _scoreBins;

  double getScore(int index) => _scoreBins[index].weight;

  void updateScore(int index, double newWeight) {
    _scoreBins = [..._scoreBins];
    _scoreBins[index].weight = newWeight;
    notifyListeners();
  }

  Category getCategory(int index) => categories[index];

  void updateCategory(int index, String newLabel, double newWeight) {
    categories = [...categories];
    categories[index].label = newLabel;
    categories[index].weight = newWeight;
    notifyListeners();
  }

  void addCategory(String label, double weight) {
    categories.add(Category(label: label, weight: weight));
    notifyListeners();
  }

  void removeCategory(int index) {
    categories.removeAt(index);
    notifyListeners();
  }

  bool isCategoryLabelUsed(int index, String label) {
    bool retval = false;
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].label == label && i != index) {
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
}

class SemanticValue {
  double weight;

  SemanticValue({required this.weight});
}

class Category extends SemanticValue {
  String label;

  Category({required this.label, required double weight})
      : super(weight: weight);
}
