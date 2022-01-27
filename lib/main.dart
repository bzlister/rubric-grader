import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/files/file_explorer.dart';
import 'package:flapp/routes/options/options.dart';
import 'package:flapp/routes/rubric/rubric_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => Rubric.example(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubric Grader',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: 'Allison',
        brightness: Brightness.dark,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orange,
          selectionHandleColor: Colors.orange,
          selectionColor: Colors.orange,
        ),
      ),
      initialRoute: '/rubric',
      routes: {
        '/rubric': (context) => const RubricContainer(),
        '/files/save': (context) => const FileExplorer.save(),
        '/files/open': (context) => const FileExplorer.open(),
        '/files/export': (context) => const FileExplorer.export(),
        '/options': (context) => const Options(),
      },
    );
  }
}
