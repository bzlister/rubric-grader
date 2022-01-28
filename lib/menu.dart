import 'package:flutter/material.dart';

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
                Navigator.pushNamed(context, '/rubric');
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          content: Text(
                            "Save rubric 'Assignment 1'?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'files/save');
                              },
                              child: const Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/rubric');
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
                Navigator.pushNamed(context, '/files/open');
              },
            ),
            ListTile(
              leading: const Icon(Icons.save),
              title: const Text("Save"),
              onTap: () {
                Navigator.pushNamed(context, '/files/save');
              },
            ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text("Export"),
              onTap: () {
                Navigator.pushNamed(context, '/files/export');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Options"),
              onTap: () {
                Navigator.pushNamed(context, '/options');
              },
            ),
          ],
        ),
      ),
    );
  }
}
