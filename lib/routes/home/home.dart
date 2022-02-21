import 'package:flapp/menu.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/saved_rubric_card.dart';
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
                (index) => SavedRubricCard(rubric: savedRubrics[index]),
              ),
            ),
            selector: (context, grader) => grader.savedRubrics,
          ),
        ),
      ),
    );
  }
}
