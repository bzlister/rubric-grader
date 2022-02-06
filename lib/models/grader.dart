import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/options/components/theme_option.dart';
import 'package:flapp/score_selection_paradigm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Grader extends ChangeNotifier {
  Rubric? _currentRubric;
  List<Rubric> _savedRubrics;
  GradingScale _gradingScale;
  ScoreSelectionParadigm _scoreSelectionParadigm;
  ThemeData _themeData;

  Grader(
    this._currentRubric,
    this._savedRubrics,
    this._gradingScale,
    this._scoreSelectionParadigm,
    this._themeData,
  );

  Grader.init()
      : _savedRubrics = [],
        _gradingScale = GradingScale.collegeBoard(),
        _scoreSelectionParadigm = ScoreSelectionParadigm.bin,
        _themeData = ThemeData.dark();

  set currentRubric(Rubric? rubric) {
    _currentRubric = rubric;
    notifyListeners();
  }

  Rubric? get currentRubric => _currentRubric;

  GradingScale get gradingScale => _gradingScale;

  set gradingScale(GradingScale scale) {
    _gradingScale = scale;
    notifyListeners();
  }

  get defaultAssignmentName {
    try {
      List<String> matches = [];
      for (var i = 0; i < _savedRubrics.length; i++) {
        if (RegExp(r"^Assignment \d+$")
            .hasMatch(_savedRubrics[i].assignmentName)) {
          matches.add(_savedRubrics[i].assignmentName);
        }
      }

      int greatest = 0;
      for (var j = 0; j < matches.length; j++) {
        int defaultAssignmentNum =
            int.parse(matches[j].substring(matches[j].indexOf(" ")));
        if (defaultAssignmentNum > greatest) {
          greatest = defaultAssignmentNum;
        }
      }
      return "Assignment ${greatest + 1}";
    } catch (exception) {
      return "Assignment 1";
    }
  }
}
