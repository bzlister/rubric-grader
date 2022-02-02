import 'dart:js';

import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/files/file_explorer.dart';
import 'package:flapp/routes/options/options.dart';
import 'package:flapp/routes/rubric/rubric_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Grader.init()),
      ChangeNotifierProxyProvider<Grader, Rubric>(
        create: (context) => Rubric.empty(),
        update: (context, grader, rubric) {
          if (grader.currentRubric != null) {
            return grader.currentRubric!;
          } else if (rubric != null) {
            return rubric;
          }
          throw Exception(
              "error in rubric provider. ${grader.currentRubric == null} ${rubric == null}");
        },
      ),
      ChangeNotifierProxyProvider<Rubric, GradedAssignment>(
        create: (context) => GradedAssignment.empty(),
        update: (context, rubric, gradedAssignment) {
          if (gradedAssignment != null) {
            return gradedAssignment..rubric = rubric;
          }
          throw Exception(
              "error in graded assignment provider. ${gradedAssignment == null}");
        },
      )
    ],
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
