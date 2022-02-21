import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

class SavedRubricCard extends StatefulWidget {
  final Rubric rubric;
  const SavedRubricCard({Key? key, required this.rubric}) : super(key: key);

  @override
  _SavedRubricCardState createState() => _SavedRubricCardState();
}

class _SavedRubricCardState extends State<SavedRubricCard> {
  late Widget _collapsedContent;
  late List<Widget> _expandedContent;

  @override
  void initState() {
    _collapsedContent = Text(widget.rubric.assignmentName);
    _expandedContent = widget.rubric.gradedAssignments
        .map(
          (element) => Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 2),
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
                  element.name!,
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        )
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, bottom: 1, left: 5, right: 5),
      child: ExpansionTileCard(
        title: _collapsedContent,
        children: _expandedContent,
        baseColor: Theme.of(context).cardColor,
      ),
    );
  }
}
