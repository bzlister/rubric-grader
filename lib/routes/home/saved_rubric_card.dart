import 'package:flapp/models/grader.dart';
import 'package:flapp/models/models_util.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flapp/routes/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:provider/src/provider.dart';
import 'package:tuple/tuple.dart';

class SavedRubricCard extends StatefulWidget {
  final Grader grader;
  final Rubric rubric;
  final Key tileKey;
  final void Function(bool) onExpansionChanged;

  const SavedRubricCard({
    Key? key,
    required this.grader,
    required this.rubric,
    required this.tileKey,
    required this.onExpansionChanged,
  }) : super(key: key);

  @override
  _SavedRubricCardState createState() => _SavedRubricCardState();
}

class _SavedRubricCardState extends State<SavedRubricCard> {
  late Widget _collapsedContent;
  late List<Widget> _expandedContent;

  @override
  void initState() {
    _collapsedContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(widget.rubric.assignmentName), Text('(${widget.rubric.gradedAssignments.length})')],
    );
    _expandedContent = widget.rubric.gradedAssignments.map(
      (element) {
        Tuple2<String, double> grade = ModelsUtil.calcGrade(widget.grader, widget.rubric, element);
        return Padding(
          padding: const EdgeInsets.only(left: 25, bottom: 2),
          child: GestureDetector(
            onTap: () {
              context.read<HomeState>().bottomNavigationMode = BottomNavigationMode.singleStudentOptions;
              context.read<HomeState>().setSelected(widget.rubric, [element]);
            },
            onLongPress: () {
              context.read<HomeState>().bottomNavigationMode = BottomNavigationMode.multiStudentOptions;
              context.read<HomeState>().setSelected(widget.rubric, widget.rubric.gradedAssignments);
            },
            child: AbsorbPointer(
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '\u2022',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      element.name.length > 100 ? '${element.name.substring(0, 100)}...' : element.name,
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    Text('${grade.item1} (${grade.item2.toStringAsFixed(1)}%)')
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      child: SingleChildScrollView(
        child: ExpansionTileCard(
          key: widget.tileKey,
          onExpansionChanged: widget.onExpansionChanged,
          title: _collapsedContent,
          children: _expandedContent,
          baseColor: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
