import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'components/menu.dart';
import 'components/rubric_container.dart';
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
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Selector<Rubric, String>(
            builder: (context, assignmentName, child) => TextField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              onSubmitted: (value) {
                context.read<Rubric>().setAssignmentName(value);
              },
              textInputAction: TextInputAction.go,
              controller: TextEditingController(text: assignmentName),
            ),
            selector: (context, rubric) => rubric.assignmentName,
          ),
          toolbarHeight: 40,
        ),
        drawer: Menu(),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
          child: RubricContainer(),
        ),
      ),
    );
  }
}
