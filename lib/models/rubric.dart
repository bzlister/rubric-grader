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

  double get totalPoints => categories.map((c) => c.weight).sum;

/*
  double get earnedPoints {
    double points = 0;
    for (int i = 0; i < categories.length; i++) {
      int indx = -1; // getSelection(i);
      if (indx != -1) {
        points += categories[i].weight * _scoreBins[indx].weight * 0.01;
      }
    }
    return points;
  }
*/

/*
  int getSelection(int categoryIndex) {
    if (categories[categoryIndex].selected != null) {
      return _scoreBins.indexWhere(
          (score) => score.id == categories[categoryIndex].selected);
    }
    return -1;
  }
*/

/*
  void makeSelection(int categoryIndex, int rowIndex) {
    categories[categoryIndex].selected = _scoreBins[rowIndex].id;
    notifyListeners();
  }
*/

/*
  void cancelSelection(int categoryIndex) {
    categories[categoryIndex].selected = null;
    notifyListeners();
  }
*/

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  List<double> get scores => _scoreBins.map((score) => score.weight).toList();

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

/*
  int get daysLate => _daysLate;
*/

  int maxDaysLate() => (100.0 / latePercentagePerDay).ceil();

/*
  set daysLate(int numDays) {
    _daysLate = numDays;
    notifyListeners();
  }
*/

  double get latePercentagePerDay => _latePercentagePerDay;

  set latePercentagePerDay(double percentage) {
    _latePercentagePerDay = percentage;
    notifyListeners();
  }

/*
  double get latePenalty {
    double percentageOff = daysLate * latePercentagePerDay * 0.01;
    return min(
      percentageOff * (latePolicy == "total" ? totalPoints : earnedPoints),
      earnedPoints,
    );
  }
*/

/*
  Tuple2<String, double> calcGrade() {
    if (totalPoints == 0) {
      return const Tuple2("", 0);
    }
    double finalScore = (earnedPoints - latePenalty) / totalPoints * 100;
    String label = _gradingScale.scale[0].item1;
    for (int i = 0; i < _gradingScale.scale.length; i++) {
      if (_gradingScale.scale[i].item2 <= finalScore) {
        label = _gradingScale.scale[i].item1;
        break;
      }
    }
    return Tuple2(label, finalScore);
  }
*/

/*
  double calcGrade() {
    if (totalPoints == 0) {
      return 0;
    }
    double finalScore = (earnedPoints - latePenalty) / totalPoints * 100;
    return finalScore;
  }
*/

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
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
