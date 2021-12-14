import 'package:flutter/material.dart';

class RubricCategory extends StatefulWidget {
  const RubricCategory(
      {Key? key, required this.percentValue, required this.categoryName})
      : super(key: key);

  final double percentValue;
  final String categoryName;

  @override
  State<RubricCategory> createState() => _RubricCategoryState();
}

class _RubricCategoryState extends State<RubricCategory> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        child: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              widget.categoryName,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        height: 50,
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
