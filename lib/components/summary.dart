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
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Total:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, double>(
                  builder: (context, total, child) => Text(
                    total.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 15),
                  ),
                  selector: (context, rubric) => rubric.totalPoints,
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Earned:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Selector<Rubric, double>(
                  builder: (context, earned, child) => Text(
                    earned.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 15),
                  ),
                  selector: (context, rubric) => rubric.earnedPoints,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
