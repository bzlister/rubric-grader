import 'package:flutter/material.dart';

class OptionGroup extends StatelessWidget {
  final List<Widget> optionsList;

  const OptionGroup({Key? key, required this.optionsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5, top: 8, bottom: 5),
        child: Column(
          children: List.generate(optionsList.length, (index) {
            if (index < optionsList.length - 1) {
              return Wrap(
                children: [Align(alignment: Alignment.bottomLeft, child: optionsList[index]), const Divider()],
              );
            } else {
              return Align(alignment: Alignment.bottomLeft, child: optionsList[index]);
            }
          }),
        ),
      ),
    );
  }
}
