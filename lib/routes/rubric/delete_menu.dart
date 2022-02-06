import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteMenu extends StatelessWidget {
  final String categoryLabel;
  final int index;

  const DeleteMenu({Key? key, required this.categoryLabel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Text("Delete category '$categoryLabel'?"),
        actions: [
          TextButton(
            onPressed: () {
              context
                  .read<GradedAssignment>()
                  .selections
                  .remove(context.read<Rubric>().categories[index].xid);
              context.read<Rubric>().removeCategory(index);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Yes',
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'No',
              textAlign: TextAlign.center,
            ),
          ),
        ]);
  }
}
