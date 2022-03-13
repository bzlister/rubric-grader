import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/expandable_list_tile.dart';
import 'package:flapp/routes/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SavedRubricCard extends StatelessWidget {
  final Rubric rubric;

  const SavedRubricCard({
    Key? key,
    required this.rubric,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Selector<HomeState, bool>(
          builder: (context, shouldExpand, child) => ExpandableListTile(
            expanded: shouldExpand,
            onExpandPressed: () {
              context.read<HomeState>().minimize(shouldExpand ? null : rubric);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(rubric.assignmentName!), Text('(${rubric.gradedAssignments.length})')],
            ),
            child: Selector<HomeState, BottomNavigationMode>(
              builder: (context, bottomNavMode, child) => Column(children: [
                ...rubric.gradedAssignments.map(
                  (element) {
                    Tuple2<String, double> grade = ModelsUtil.calcGrade(context.read<Grader>(), rubric, element);
                    return Selector<HomeState, bool>(
                      builder: (context, isSelected, child) {
                        Color? color = isSelected ? context.read<Grader>().themeData.toggleableActiveColor : null;
                        FontWeight? weight = isSelected ? FontWeight.bold : null;
                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              context.read<HomeState>().removeSelected(element);
                            } else {
                              if (bottomNavMode == BottomNavigationMode.singleStudentOptions) {
                                context.read<HomeState>().clear(element);
                              } else {
                                context.read<HomeState>().addSelected(element);
                              }
                            }
                          },
                          onLongPress: () {
                            context.read<HomeState>().bottomNavigationMode = BottomNavigationMode.multiStudentOptions;
                            context.read<HomeState>().addSelected(element);
                          },
                          child: AbsorbPointer(
                            child: ListTile(
                              minLeadingWidth: 1,
                              leading: SizedBox(
                                  width: 50,
                                  child: bottomNavMode == BottomNavigationMode.singleStudentOptions
                                      ? Center(
                                          child: Text(
                                            '-',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: isSelected ? FontWeight.bold : null,
                                                color: color),
                                          ),
                                        )
                                      : Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            if (value!) {
                                              context.read<HomeState>().addSelected(element);
                                            } else {
                                              context.read<HomeState>().removeSelected(element);
                                            }
                                          },
                                        )),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.name!.length > 20 ? '${element.name!.substring(0, 20)}...' : element.name!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(color: color, fontWeight: weight),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${grade.item1} (${grade.item2.toStringAsFixed(1)}%)',
                                    style: TextStyle(color: color, fontWeight: weight),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      selector: (context, homeState) => homeState.selected.contains(element),
                    );
                  },
                ).toList(),
                TextButton(
                  child: Text("+ Grade new"),
                  onPressed: () {
                    context.read<Rubric>().load(rubric);
                    context.read<GradedAssignment>().reset();
                    Navigator.pushNamed(context, '/rubric');
                  },
                )
              ]),
              selector: (context, homeState) => homeState.bottomNavigationMode,
            ),
            // baseColor: Theme.of(context).cardColor,
          ),
          selector: (context, homeState) => homeState.shouldExpand(rubric.xid),
        ),
      ),
    );
  }
}
