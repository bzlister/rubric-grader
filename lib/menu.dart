import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/save_assignment_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

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
            Selector<Rubric, String>(
                builder: (context, assignmentName, child) => ListTile(
                      leading: const Icon(Icons.new_releases),
                      title: Text(assignmentName),
                      onTap: () {
                        Navigator.pop(context);
                        if (ModalRoute.of(context)?.settings.name != "/rubric") {
                          Navigator.pushNamed(context, '/rubric');
                        }
                      },
                    ),
                selector: (context, rubric) => rubric.assignmentName),
            Selector2<Rubric, GradedAssignment, bool>(
              builder: (context, isChanged, child) {
                return Visibility(
                  visible: isChanged,
                  child: ListTile(
                    leading: const Icon(Icons.new_label),
                    title: const Text("New rubric"),
                    onTap: () {
                      Navigator.pop(context);
                      if (ModalRoute.of(context)?.settings.name != "/rubric") {
                        Navigator.pushNamed(context, '/rubric');
                      }
                      Rubric rubric = context.read<Rubric>();
                      Grader grader = context.read<Grader>();
                      GradedAssignment gradedAssignment = context.read<GradedAssignment>();

                      ModelsUtil.onSave(grader, rubric, gradedAssignment, context, true);
                    },
                  ),
                );
              },
              selector: (context, rubric, gradedAssignment) =>
                  rubric.getState() != Rubric.empty(context.read<Grader>().defaultAssignmentName).getState() ||
                  gradedAssignment.getState() != GradedAssignment.empty(rubric.defaultStudentName).getState(),
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
