import 'dart:math';
import 'package:flapp/models/grading_scale.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter/cupertino.dart';

class Rubric extends ChangeNotifier {
  String _assignmentName;
  List<ScoreContainer> _scores;
  List<CategoryContainer> _categories;
  String _latePolicy;
  int _daysLate;
  double _latePercentagePerDay;
  GradingScale _gradingScale;
  String _comment;

  Rubric(
    this._assignmentName,
    this._scores,
    this._categories,
    this._latePolicy,
    this._daysLate,
    this._latePercentagePerDay,
    this._gradingScale,
    this._comment,
  );

  Rubric.example()
      : _assignmentName = "Assignment 1",
        _scores = [
          ScoreContainer(weight: 100),
          ScoreContainer(weight: 85),
          ScoreContainer(weight: 75),
          ScoreContainer(weight: 70),
          ScoreContainer(weight: 60),
        ],
        _categories = [
          CategoryContainer(label: "Audience & Genre", weight: 60),
          CategoryContainer(label: "Thesis & Support", weight: 60),
          CategoryContainer(label: "Reasoning", weight: 40),
          CategoryContainer(label: "Organization & Style", weight: 30),
          CategoryContainer(label: "Correctness", weight: 10)
        ],
        _latePolicy = "total",
        _daysLate = 0,
        _latePercentagePerDay = 20,
        _gradingScale = GradingScale.collegeBoard(),
        _comment = "";

  double get totalPoints => _categories
      .map((c) => c.data.weight)
      .reduce((value, element) => value + element);

  double get earnedPoints {
    double points = 0;
    for (int i = 0; i < _categories.length; i++) {
      int indx = getSelection(i);
      if (indx != -1) {
        points += _categories[i].data.weight * _scores[indx]._weight * 0.01;
      }
    }
    return points;
  }

  int getSelection(int categoryIndex) {
    if (_categories[categoryIndex].selected != null) {
      return _scores.indexWhere(
          (score) => score.id == _categories[categoryIndex].selected);
    }
    return -1;
  }

  void makeSelection(int categoryIndex, int rowIndex) {
    _categories[categoryIndex].selected = _scores[rowIndex].id;
    notifyListeners();
  }

  void cancelSelection(int categoryIndex) {
    _categories[categoryIndex].selected = null;
    notifyListeners();
  }

  String get assignmentName => _assignmentName;

  void setAssignmentName(String value) {
    _assignmentName = value;
    notifyListeners();
  }

  List<double> get scores => _scores.map((score) => score.weight).toList();

  double getScore(int index) => _scores[index].weight;

  void updateScore(int index, double newWeight) {
    _scores = [..._scores];
    _scores[index].update(newWeight);
    notifyListeners();
  }

  List<Category> get categories =>
      _categories.map((category) => category.data).toList();

  Category getCategory(int index) => _categories[index].data;

  void updateCategory(int index, String newLabel, double newWeight) {
    _categories = [..._categories];
    _categories[index].update(newLabel, newWeight);
    notifyListeners();
  }

  void addCategory(String label, double weight) {
    _categories.add(CategoryContainer(label: label, weight: weight));
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
      earnedPoints,
    );
  }

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

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
    notifyListeners();
  }
}

class ScoreContainer {
  UniqueKey id;
  double _weight;

  ScoreContainer({required double weight})
      : _weight = weight,
        id = UniqueKey();

  double get weight => _weight;

  void update(double newWeight) {
    _weight = newWeight;
  }
}

class CategoryContainer {
  Category _data;
  UniqueKey id;
  UniqueKey? selected;

  CategoryContainer({required String label, required double weight})
      : id = UniqueKey(),
        _data = Category(label, weight);

  Category get data => _data;

  void update(String newLabel, double newWeight) {
    _data = Category(newLabel, newWeight);
  }

  void select(UniqueKey selectedId) {
    selected = selectedId;
  }

  @override
  bool operator ==(Object other) {
    if (other is CategoryContainer) {
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

class Category extends Tuple2<String, double> {
  Category(String label, double weight) : super(label, weight);

  String get label => item1;
  double get weight => item2;
}
