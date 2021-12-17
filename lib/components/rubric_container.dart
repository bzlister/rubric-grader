import 'package:flapp/components/quantity_selector.dart';
import 'package:flapp/components/rubric.dart';
import 'package:flapp/models/factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

class RubricContainer extends StatefulWidget {
  const RubricContainer({Key? key}) : super(key: key);

  @override
  State<RubricContainer> createState() => _RubricContainerState();
}

class _RubricContainerState extends State<RubricContainer> {
  late List<Factor> grades;
  late List<Factor> categories;
  late int totalPoints;
  final _formKey = GlobalKey<FormState>();
  late String _text;

  @override
  void initState() {
    super.initState();
    // default starting rubric
    grades = [
      Factor("A", 1.0),
      Factor("B", 0.85),
      Factor("C", 0.75),
      Factor("D", 0.7),
      Factor("F", 0.6)
    ];
    categories = [
      Factor("Zaudience & Genre", 0.3),
      Factor("Thesis & Support", 0.3),
      Factor("Reasoning", 0.2),
      Factor("Organization & Style", 0.15),
      Factor("Correctness", 0.05)
    ];
    totalPoints = 200;
    _text = "V";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            child: Text(
              _text,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => QuantitySelector(
                  onChanged: (value) {
                    setState(() {
                      _text = value.toString();
                    });
                  },
                ),
              );
            },
          ),
        ),
        Rubric(
          categories: categories,
          grades: grades,
          totalPoints: totalPoints,
        ),
      ],
    );
  }
}

/*
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_text),
              TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  if (value != null && value.isNotEmpty) {
                    setState(() {
                      _text = value;
                    });
                  }
                },
              )
            ],
          ),
        )
*/