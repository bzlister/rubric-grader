import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/expandable_list_tile.dart';
import 'package:flapp/routes/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class SavedRubricCard extends StatefulWidget {
  final Rubric rubric;

  const SavedRubricCard({
    Key? key,
    required this.rubric,
  }) : super(key: key);

  @override
  _SavedRubricCardState createState() => _SavedRubricCardState();
}

class _SavedRubricCardState extends State<SavedRubricCard> {
  late Widget _collapsedContent;

  @override
  void initState() {
    _collapsedContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(widget.rubric.assignmentName), Text('(${widget.rubric.gradedAssignments.length})')],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      child: SingleChildScrollView(
        child: Selector<HomeState, bool>(
          builder: (context, shouldExpand, child) => ExpandableListTile(
            expanded: shouldExpand,
            onExpandPressed: () {
              context.read<HomeState>().minimize(shouldExpand ? null : widget.rubric.xid);
            },
            title: _collapsedContent,
            child: Selector<HomeState, BottomNavigationMode>(
              builder: (context, bottomNavMode, child) => Column(
                  children: widget.rubric.gradedAssignments.map(
                (element) {
                  Tuple2<String, double> grade = ModelsUtil.calcGrade(context.read<Grader>(), widget.rubric, element);
                  return Selector<HomeState, bool>(
                    builder: (context, isSelected, child) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 2),
                        child: GestureDetector(
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                bottomNavMode == BottomNavigationMode.singleStudentOptions
                                    ? const Text(
                                        '\u2022',
                                        style: TextStyle(
                                          fontSize: 17,
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
                                      ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  element.name.length > 100 ? '${element.name.substring(0, 100)}...' : element.name,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: isSelected
                                          ? context.read<Grader>().themeData.textSelectionTheme.selectionColor
                                          : null),
                                ),
                                const Spacer(),
                                Text('${grade.item1} (${grade.item2.toStringAsFixed(1)}%)')
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    selector: (context, homeState) => homeState.selected.contains(element),
                  );
                },
              ).toList()),
              selector: (context, homeState) => homeState.bottomNavigationMode,
            ),
            // baseColor: Theme.of(context).cardColor,
          ),
          selector: (context, homeState) => homeState.shouldExpand(widget.rubric.xid),
        ),
      ),
    );
  }
}
