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
          children: const <Widget>[
            ListTile(
                title: Text(
              "Rubric Grader",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            )),
            Divider(),
            ListTile(leading: Icon(Icons.save), title: Text("Save")),
            ListTile(leading: Icon(Icons.import_export), title: Text("Export")),
            ListTile(leading: Icon(Icons.folder_open), title: Text("Open")),
            ListTile(leading: Icon(Icons.settings), title: Text("Options")),
          ],
        ),
      ),
    );
  }
}
