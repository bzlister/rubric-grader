import 'package:flutter/material.dart';

import 'components/rubric_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubric Grader',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const Scaffold(
          body: Padding(
              padding: EdgeInsets.only(top: 5), child: RubricContainer())),
    );
  }
}
