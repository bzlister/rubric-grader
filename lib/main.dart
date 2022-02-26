import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/home.dart';
import 'package:flapp/routes/options/options.dart';
import 'package:flapp/routes/rubric/rubric_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Grader.init()),
      ChangeNotifierProvider(
        create: (context) => Rubric.empty(context.read<Grader>().defaultAssignmentName),
      ),
      ChangeNotifierProvider(
        create: (context) => GradedAssignment.empty(context.read<Rubric>().defaultStudentName),
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
        '/options': (context) => const Options(),
        '/home': (context) => const Home()
      },
    );
  }
}
