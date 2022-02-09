import 'package:flapp/menu.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rubric Grader")),
      drawer: const Menu(),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 1, right: 1, bottom: 1),
        child: SingleChildScrollView(
          child: Selector<Grader, List<Rubric>>(
            builder: (context, savedRubrics, child) => Column(
              children: List.generate(
                savedRubrics.length,
                (index) => Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Card(
                    margin: const EdgeInsets.only(
                        left: 4, right: 4, top: 2, bottom: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(savedRubrics[index].assignmentName),
                          ),
                          const Spacer(),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                  "${savedRubrics[index].gradedAssignments.length} graded"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            selector: (context, grader) => grader.savedRubrics,
          ),
        ),
      ),
    );
  }
}
