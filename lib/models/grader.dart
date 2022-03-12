import 'package:flapp/grading_scale.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/score_selection_paradigm.dart';
import 'package:flapp/themes.dart';
import 'package:flutter/material.dart';
import 'package:xid/xid.dart';

class Grader extends ChangeNotifier {
  List<Rubric> _savedRubrics;
  GradingScale _gradingScale;
  ScoreSelectionParadigm _scoreSelectionParadigm;
  ThemeData _themeData;
  int _assignmentNum = 1;
  int _offset = 0;

  Grader(
    this._savedRubrics,
    this._gradingScale,
    this._scoreSelectionParadigm,
    this._themeData,
  );

  Grader.init()
      : _savedRubrics = [],
        _gradingScale = GradingScale.collegeBoard(),
        _scoreSelectionParadigm = ScoreSelectionParadigm.bin,
        _themeData = Themes.light;

  ScoreSelectionParadigm get scoreSelectionParadigm => _scoreSelectionParadigm;

  set scoreSelectionParadigm(ScoreSelectionParadigm newParadigm) {
    _scoreSelectionParadigm = newParadigm;
    notifyListeners();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }

  void saveRubric(Rubric rubric) {
    int indx = -1;
    for (var i = 0; i < _savedRubrics.length; i++) {
      if (_savedRubrics[i].xid == rubric.xid) {
        indx = i;
        break;
      }
    }

    Rubric copy = Rubric(rubric.assignmentName, [...rubric.scoreBins], [...rubric.categories], rubric.latePolicy,
        rubric.latePercentagePerDay, [...rubric.gradedAssignments], rubric.xid);

    if (indx != -1) {
      _savedRubrics[indx] = copy;
    } else {
      _savedRubrics.add(copy);
    }
    _savedRubrics = [..._savedRubrics];
    _assignmentNum = _calcDefaultAssignmentNum();
    notifyListeners();
  }

  void deleteRubric(Rubric rubric) {
    _savedRubrics = [..._savedRubrics.where((r) => r.xid != rubric.xid)];
    _assignmentNum = _calcDefaultAssignmentNum();
    notifyListeners();
  }

  List<Rubric> get savedRubrics => _savedRubrics;

  GradingScale get gradingScale => _gradingScale;

  set gradingScale(GradingScale scale) {
    _gradingScale = scale;
    notifyListeners();
  }

  String get defaultAssignmentName => 'Assignment $_assignmentNum';

  int _calcDefaultAssignmentNum() {
    try {
      List<String> matches = [];
      for (var i = 0; i < _savedRubrics.length; i++) {
        if (RegExp(r"^Assignment \d+$").hasMatch(_savedRubrics[i].assignmentName!)) {
          matches.add(_savedRubrics[i].assignmentName!);
        }
      }

      int greatest = _offset;
      for (var j = 0; j < matches.length; j++) {
        int defaultAssignmentNum = int.parse(matches[j].substring(matches[j].indexOf(" ")));
        if (defaultAssignmentNum > greatest) {
          greatest = defaultAssignmentNum;
        }
      }
      return greatest + 1;
    } catch (exception) {
      return _assignmentNum;
    }
  }

  Rubric? findRubricByXid(Xid xid) {
    try {
      return _savedRubrics.firstWhere((element) => element.xid == xid);
    } on StateError {
      return null;
    }
  }
}
