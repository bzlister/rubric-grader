import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/options/components/theme_option.dart';
import 'package:flapp/score_selection_paradigm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GraderState extends ChangeNotifier {
  Rubric? _currentRubric;
  List<Rubric> _savedRubrics;
  GradingScale _gradingScale;
  ScoreSelectionParadigm _scoreSelectionParadigm;
  ThemeData _themeData;

  GraderState(
    this._currentRubric,
    this._savedRubrics,
    this._gradingScale,
    this._scoreSelectionParadigm,
    this._themeData,
  );

  GraderState.init()
      : _savedRubrics = [Rubric.example()],
        _gradingScale = GradingScale.collegeBoard(),
        _scoreSelectionParadigm = ScoreSelectionParadigm.bin,
        _themeData = ThemeData.dark();
}
