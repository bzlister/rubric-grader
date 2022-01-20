import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: const <Widget>[
      ListTile(leading: Icon(Icons.save), title: Text("Save")),
      ListTile(leading: Icon(Icons.access_alarm), title: Text("Export")),
      ListTile(leading: Icon(Icons.ac_unit), title: Text("Open")),
      ListTile(leading: Icon(Icons.gavel_sharp), title: Text("Options")),
    ]));
  }
}
