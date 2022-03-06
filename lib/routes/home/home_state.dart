import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';

class HomeState extends ChangeNotifier {
  List<bool> _showBottomNavigationVotes;
  List<GradedAssignment> _selectedGradedAssignments;
  Rubric? _selectedRubric;
  BottomNavigationMode _bottomNavigationMode;

  HomeState({required showBottomNavigationVotes})
      : _showBottomNavigationVotes = showBottomNavigationVotes,
        _bottomNavigationMode = BottomNavigationMode.singleStudentOptions,
        _selectedGradedAssignments = [],
        super();

  bool shouldShow() => _selectedGradedAssignments.isNotEmpty && _showBottomNavigationVotes.any((vote) => vote);

  void setVote(int index, bool value) {
    _showBottomNavigationVotes[index] = value;
    notifyListeners();
  }

  BottomNavigationMode get bottomNavigationMode => _bottomNavigationMode;

  set bottomNavigationMode(BottomNavigationMode mode) {
    _bottomNavigationMode = mode;
    notifyListeners();
  }

  List<GradedAssignment> get selected => _selectedGradedAssignments;

  Rubric get rubric => _selectedRubric!;

  setSelected(Rubric rubric, List<GradedAssignment> selection) {
    _selectedRubric = rubric;
    _selectedGradedAssignments = [...selection];
    notifyListeners();
  }
}

enum BottomNavigationMode {
  singleStudentOptions,
  multiStudentOptions,
}
