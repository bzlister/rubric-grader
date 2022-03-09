import 'package:flapp/routes/home/expandable_section.dart';
import 'package:flapp/routes/home/rotatable_section.dart';
import 'package:flutter/material.dart';

class ExpandableListTile extends StatelessWidget {
  final Widget title;
  final bool expanded;
  final Widget child;
  final void Function() onExpandPressed;

  const ExpandableListTile(
      {Key? key, required this.title, required this.expanded, required this.onExpandPressed, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        title: title,
        onTap: onExpandPressed,
        trailing: IconButton(
          onPressed: onExpandPressed,
          // icon: Icon(Icons.expand_more),
          icon: RotatableSection(
              rotated: expanded,
              child: const SizedBox(
                height: 30,
                width: 30,
                child: Icon(Icons.expand_more),
              )),
        ),
      ),
      ExpandableSection(
        child: child,
        expand: expanded,
      )
    ]);
  }
}
