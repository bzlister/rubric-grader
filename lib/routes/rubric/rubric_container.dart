import 'package:flapp/menu.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/rubric/grades_selector.dart';
import 'package:flapp/routes/rubric/header.dart';
import 'package:flapp/routes/rubric/rubric_table.dart';
import 'package:flapp/routes/rubric/summary.dart';
import 'package:flapp/save_assignment_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatelessWidget {
  final double leftColumnWidth = 85;
  const RubricContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: Selector3<Grader, Rubric, GradedAssignment, bool>(
                  builder: (context, isEdited, child) => IconButton(
                    onPressed: isEdited
                        ? () {
                            Grader grader = context.read<Grader>();
                            Rubric rubric = context.read<Rubric>();
                            GradedAssignment gradedAssignment = context.read<GradedAssignment>();
                            EditedStatus editedStatus = ModelsUtil.isEdited(grader, rubric, gradedAssignment);
                            if (rubric.gradedAssignments.isNotEmpty &&
                                (editedStatus == EditedStatus.rubric ||
                                    editedStatus == EditedStatus.rubricAndAssignment)) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: const Text(
                                    "You have already graded assignments with this rubric. Saving changes to the rubric may cause scores to be recalculated.",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        if (editedStatus == EditedStatus.rubricAndAssignment) {
                                          rubric.saveGradedAssignment(gradedAssignment);
                                        }
                                        grader.saveRubric(rubric);
                                      },
                                      child: const Text('Save'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (editedStatus == EditedStatus.assignment ||
                                  editedStatus == EditedStatus.rubricAndAssignment) {
                                rubric.saveGradedAssignment(gradedAssignment);
                              }
                              grader.saveRubric(rubric);
                            }
                          }
                        : null,
                    icon: isEdited
                        ? const Icon(
                            Icons.save,
                            semanticLabel: "Save",
                          )
                        : const Icon(Icons.check),
                    disabledColor: Colors.grey,
                  ),
                  selector: (context, grader, rubric, gradedAssignment) =>
                      ModelsUtil.isEdited(grader, rubric, gradedAssignment) != EditedStatus.none,
                ),
              ),
              Expanded(
                child: Selector3<Grader, Rubric, GradedAssignment, bool>(
                    builder: (context, isEdited, child) => IconButton(
                          onPressed: isEdited
                              ? () {
                                  Grader grader = context.read<Grader>();
                                  Rubric rubric = context.read<Rubric>();
                                  GradedAssignment gradedAssignment = context.read<GradedAssignment>();
                                  if (ModelsUtil.isEdited(grader, rubric, gradedAssignment) ==
                                      EditedStatus.assignment) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => SaveAssignmentPopup(
                                            grader: grader,
                                            rubric: rubric,
                                            gradedAssignment: gradedAssignment,
                                            resetRubric: false,
                                            canShowWarning: false));
                                  } else {
                                    gradedAssignment.reset(rubric.defaultStudentName);
                                  }
                                }
                              : null,
                          icon: const Icon(
                            Icons.reset_tv,
                            semanticLabel: "Grade new student",
                          ),
                          disabledColor: Colors.grey,
                        ),
                    selector: (context, grader, rubric, gradedAssignment) {
                      EditedStatus edit = ModelsUtil.isEdited(grader, rubric, gradedAssignment);
                      return edit == EditedStatus.assignment ||
                          edit == EditedStatus.none &&
                              gradedAssignment.getState() !=
                                  GradedAssignment.empty(rubric.defaultStudentName).getState();
                    }),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Header(
            assignmentName: context.read<Rubric>().assignmentName,
            studentName: context.read<GradedAssignment>().name,
          ),
          toolbarHeight: 85,
        ),
        drawer: const Menu(),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 10),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 35,
                  child: Row(
                    children: [
                      SizedBox(
                        width: leftColumnWidth,
                      ),
                      Expanded(
                        child: Selector<Rubric, int>(
                          builder: (context, length, child) => Row(
                            children: List.generate(
                              length,
                              (index) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(3),
                                      ),
                                      child: Center(
                                        child: Selector<Rubric, double>(
                                          builder: (context, score, child) => Text(
                                            "${score.truncate()}%",
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          selector: (context, rubric) => rubric.getScore(index),
                                        ),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) => const ScoresSelector(),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                          selector: (context, rubric) => rubric.scoreBins.length,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: RubricTable(leftColumnWidth: leftColumnWidth),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: IntrinsicHeight(
                  child: Selector<Rubric, bool>(
                    builder: (context, canShowSummary, child) => canShowSummary
                        ? Column(mainAxisSize: MainAxisSize.max, children: const [
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Summary(),
                            ),
                          ])
                        : Center(
                            child: Selector<Rubric, String>(
                              builder: (context, assignmentName, child) =>
                                  Text("Tap the '+' button to add a category to $assignmentName"),
                              selector: (context, rubric) => rubric.assignmentName,
                            ),
                          ),
                    selector: (context, rubric) => rubric.totalPoints > 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
