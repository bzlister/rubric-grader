import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:xid/xid.dart';

class HomeState extends ChangeNotifier {
  List<GradedAssignment> _selectedGradedAssignments;
  Rubric? _selectedRubric;
  Map<Xid, bool> _expandCardState;
  BottomNavigationMode _bottomNavigationMode;

  HomeState({required showBottomNavigationVotes})
      : _bottomNavigationMode = BottomNavigationMode.singleStudentOptions,
        _selectedGradedAssignments = [],
        _expandCardState = {},
        super();

  bool shouldShow() => _selectedGradedAssignments.isNotEmpty;

  BottomNavigationMode get bottomNavigationMode => _bottomNavigationMode;

  set bottomNavigationMode(BottomNavigationMode mode) {
    _bottomNavigationMode = mode;
    notifyListeners();
  }

  List<GradedAssignment> get selected => _selectedGradedAssignments;

  bool shouldExpand(Xid xid) {
    return _expandCardState[xid] ?? false;
  }

  void minimize(Rubric? singleExpanded) {
    _selectedGradedAssignments = [];
    _bottomNavigationMode = BottomNavigationMode.singleStudentOptions;
    if (singleExpanded != null) {
      _selectedRubric = singleExpanded;
      _expandCardState[singleExpanded.xid] = true;
    }
    for (Xid xid in _expandCardState.keys) {
      if (xid != singleExpanded?.xid) {
        _expandCardState[xid] = false;
      }
    }
    notifyListeners();
  }

  Rubric get rubric => _selectedRubric!;

  void addSelected(GradedAssignment gradedAssignment) {
    _selectedGradedAssignments = <GradedAssignment>{..._selectedGradedAssignments, gradedAssignment}.toList();
    notifyListeners();
  }

  void removeSelected(GradedAssignment gradedAssignment) {
    _selectedGradedAssignments = [..._selectedGradedAssignments.where((ga) => ga != gradedAssignment)];
    notifyListeners();
  }

  void clear(GradedAssignment? gradedAssignment) {
    if (gradedAssignment != null) {
      _selectedGradedAssignments = [gradedAssignment];
    } else {
      _selectedGradedAssignments = [];
    }
    notifyListeners();
  }
}

enum BottomNavigationMode {
  singleStudentOptions,
  multiStudentOptions,
}
