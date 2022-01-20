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
              style: TextStyle(fontSize: 20, color: Colors.white),
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
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.only(left: 5, right: 5, top: 15),
          child: RubricContainer(),
        ),
      ),
    );
  }
}

/*
        SizedBox(
          height: 35,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Container(
                  width: 30,
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.grey, padding: EdgeInsets.all(0)),
                    child: const Icon(Icons.menu),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          barrierDismissible: true,
                          opaque: false,
                          pageBuilder: (_, anim1, anim2) => SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(-1.0, 0.0), end: Offset.zero)
                                .animate(anim1),
                            child: Menu(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Selector<Rubric, String>(
                    builder: (context, assignmentName, child) => TextField(
                      onSubmitted: (value) {
                        context.read<Rubric>().setAssignmentName(value);
                      },
                      textInputAction: TextInputAction.go,
                      controller: TextEditingController(text: assignmentName),
                    ),
                    selector: (context, rubric) => rubric.assignmentName,
                  ),
                ),
              ),
            ],
          ),
        ),
*/