import 'package:flapp/menu.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/rubric/grades_selector.dart';
import 'package:flapp/routes/rubric/rubric_table.dart';
import 'package:flapp/routes/rubric/summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RubricContainer extends StatelessWidget {
  final double leftColumnWidth = 85;
  const RubricContainer({Key? key}) : super(key: key);

  /*
        floatingActionButton: Selector3<Grader, Rubric, GradedAssignment, bool>(
          selector: (context, grader, rubric, gradedAssignment) =>
              ModelsUtil.isEdited(grader, rubric, gradedAssignment) != EditedStatus.none,
          builder: (context, shouldRender, child) => Visibility(
                visible: shouldRender,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton(
                    child: const Icon(Icons.save),
                    onPressed: () {
                      context.read<Rubric>().saveGradedAssignment(context.read<GradedAssignment>());
                      context.read<Grader>().saveRubric(context.read<Rubric>());
                    },
                  ),
                ),
              )),
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Selector3<Grader, Rubric, GradedAssignment, bool>(
                builder: (context, isEdited, child) => IconButton(
                  onPressed: isEdited
                      ? () {
                          ModelsUtil.onSave(context.read<Grader>(), context.read<Rubric>(),
                              context.read<GradedAssignment>(), context, true);
                        }
                      : null,
                  icon: isEdited
                      ? const Icon(
                          Icons.save,
                          semanticLabel: "Save",
                        )
                      : const Text("Saved  ✓"),
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
                                ModelsUtil.onSave(context.read<Grader>(), context.read<Rubric>(),
                                    context.read<GradedAssignment>(), context, false);
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
                    return edit == EditedStatus.assignment || edit == EditedStatus.rubricAndAssignment;
                  }),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Selector<Rubric, String>(
          builder: (context, assignmentName, child) => TextField(
            decoration: const InputDecoration(
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
            onSubmitted: (value) {
              context.read<Rubric>().assignmentName = value;
            },
            textInputAction: TextInputAction.go,
            controller: TextEditingController(text: assignmentName),
          ),
          selector: (context, rubric) => rubric.assignmentName,
        ),
        toolbarHeight: 50,
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
    );
  }
}
