import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
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
                print(rubric.getState());
                print(grader.currentRubric?.getState());
                if (rubric.getState() !=
                    (grader.currentRubric != null
                        ? grader.currentRubric!.getState()
                        : "Assignment 1;100.0,90.0,80.0,70.0,60.0;;total;20.0;null")) {
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
                            grader.currentRubric = Rubric.empty(grader.defaultAssignmentName);
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            grader.currentRubric = Rubric.empty(grader.defaultAssignmentName);
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
                } else {
                  grader.currentRubric = Rubric.empty(grader.defaultAssignmentName);
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
