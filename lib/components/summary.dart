import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Summary extends StatelessWidget {
  final double width = 110;
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(
                width: width,
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Total:",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ),
              Selector<Rubric, double>(
                builder: (context, total, child) => Text(
                  total.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
                selector: (context, rubric) => rubric.totalPoints,
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Container(
                width: width,
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Earned:",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ),
              Selector<Rubric, double>(
                builder: (context, earned, child) => Text(
                  earned.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
                selector: (context, rubric) => rubric.earnedPoints,
              )
            ],
          )
        ],
      ),
    );
  }
}
