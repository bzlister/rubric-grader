import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/save_assignment_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  onSaveRubric(BuildContext context, Rubric rubric, Grader grader) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
          "Save rubric '${rubric.assignmentName}'?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              grader.saveRubric(rubric);
              rubric.reset(grader.defaultAssignmentName);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (rubric.assignmentName == grader.defaultAssignmentName) {
                grader.incrementOffset();
              }
              rubric.reset(grader.defaultAssignmentName);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const ListTile(
                title: Text(
              "Rubric Grader",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            )),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.new_label),
              title: const Text("New"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/rubric") {
                  Navigator.pushNamed(context, '/rubric');
                }
                Rubric rubric = context.read<Rubric>();
                Grader grader = context.read<Grader>();
                GradedAssignment gradedAssignment = context.read<GradedAssignment>();

                EditedStatus editedStatus = ModelsUtil.isEdited(grader, rubric, context.read<GradedAssignment>());

                switch (editedStatus) {
                  case EditedStatus.none:
                    if (rubric.assignmentName == grader.defaultAssignmentName) {
                      grader.incrementOffset();
                    }
                    context.read<Rubric>().reset(grader.defaultAssignmentName);
                    break;
                  case EditedStatus.assignment:
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => SaveAssignmentPopup(
                        grader: grader,
                        rubric: rubric,
                        gradedAssignment: gradedAssignment,
                      ),
                    );
                    break;
                  case EditedStatus.rubric:
                    onSaveRubric(context, rubric, grader);
                    break;
                  case EditedStatus.rubricAndAssignment:
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => SaveAssignmentPopup(
                        grader: grader,
                        rubric: rubric,
                        gradedAssignment: gradedAssignment,
                      ),
                    );
                    break;
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/home") {
                  Navigator.pushNamed(context, '/home');
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Options"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/options") {
                  Navigator.pushNamed(context, '/options');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
