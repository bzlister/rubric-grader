import 'package:flapp/models/grader.dart';
import 'package:flapp/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeOption extends StatefulWidget {
  const ThemeOption({Key? key}) : super(key: key);

  @override
  _ThemeOptionState createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<ThemeOption> {
  late bool _darkMode;

  @override
  void initState() {
    super.initState();
    _darkMode = context.read<Grader>().themeData.brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text("Theme"),
        ),
        const Spacer(),
        SizedBox(
          width: 100,
          child: Switch(
            value: _darkMode,
            onChanged: (x) {
              setState(() {
                _darkMode = x;
                context.read<Grader>().themeData = _darkMode ? Themes.dark : Themes.light;
              });
            },
          ),
        ),
      ],
    );
  }
}
