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
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Selector<Rubric, String>(
                            builder: (context, assignmentName, child) => Text(
                              "Save rubric '$assignmentName'?",
                            ),
                            selector: (context, rubric) =>
                                rubric.assignmentName,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<Grader>()
                                    .saveRubric(context.read<Rubric>());
                                context.read<Grader>().currentRubric =
                                    Rubric.empty(context
                                        .read<Grader>()
                                        .defaultAssignmentName);
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<Grader>().currentRubric =
                                    Rubric.empty(context
                                        .read<Grader>()
                                        .defaultAssignmentName);
                              },
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            )
                          ],
                        ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text("Open"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/files/open") {
                  Navigator.pushNamed(context, '/files/open');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text("Save"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/files/save") {
                  Navigator.pushNamed(context, '/files/save');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text("Export"),
              onTap: () {
                Navigator.pop(context);
                if (ModalRoute.of(context)?.settings.name != "/files/export") {
                  Navigator.pushNamed(context, '/files/export');
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
