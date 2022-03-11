import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flapp/menu.dart';
import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/delete_popup.dart';
import 'package:flapp/routes/home/home_state.dart';
import 'package:flapp/routes/home/saved_rubric_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<Grader, HomeState>(
      update: (context, grader, _) =>
          HomeState(showBottomNavigationVotes: List.filled(grader.savedRubrics.length, false)),
      create: (context) =>
          HomeState(showBottomNavigationVotes: List.filled(context.read<Grader>().savedRubrics.length, false)),
      child: Scaffold(
        appBar: AppBar(title: const Text("Rubric Grader")),
        bottomNavigationBar: Selector<HomeState, bool>(
          builder: (context, shouldShow, child) => Visibility(
            visible: shouldShow,
            child: Selector<HomeState, Tuple3<Rubric, List<GradedAssignment>, BottomNavigationMode>>(
              builder: (context, data, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (data.item3 == BottomNavigationMode.singleStudentOptions) ...[
                      IconButton(
                          onPressed: () {
                            context.read<GradedAssignment>().load(data.item2[0]);
                            context.read<Rubric>().load(data.item1);
                          },
                          icon: const Icon(Icons.edit))
                    ],
                    IconButton(onPressed: () {}, icon: const Icon(Icons.import_export)),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => DeletePopup(
                              containingRubric: data.item1,
                              assignmentsToDelete: data.item2,
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete))
                  ],
                );
              },
              selector: (context, homeState) => Tuple3<Rubric, List<GradedAssignment>, BottomNavigationMode>(
                homeState.rubric,
                homeState.selected,
                homeState.bottomNavigationMode,
              ),
            ),
          ),
          selector: (context, homeState) => homeState.shouldShow(),
        ),
        drawer: const Menu(),
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 1, right: 1, bottom: 1),
          child: SingleChildScrollView(
            child: Selector<Grader, int>(
              builder: (context, numRubrics, child) => Column(
                children: List.generate(
                  numRubrics,
                  (index) => Selector<Grader, Rubric>(
                      selector: (context, grader) => grader.savedRubrics[index],
                      builder: (context, rubric, child) => SavedRubricCard(rubric: rubric)),
                ),
              ),
              selector: (context, grader) => grader.savedRubrics.length,
            ),
          ),
        ),
      ),
    );
  }
}
