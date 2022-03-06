import 'package:flapp/models/graded_assignment.dart';
import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class LatePenaltySelector extends StatefulWidget {
  const LatePenaltySelector({Key? key}) : super(key: key);

  @override
  createState() => _LatePenaltySelectorState();
}

class _LatePenaltySelectorState extends State<LatePenaltySelector> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text("Late work:"),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: SizedBox(
                      child: Selector<Rubric, double>(
                        builder: (context, latePercentagePerDay, child) => TextFormField(
                          controller: TextEditingController(text: latePercentagePerDay.toStringAsFixed(0)),
                          textAlign: TextAlign.center,
                          textInputAction: TextInputAction.go,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          decoration: const InputDecoration(
                            prefixText: "-",
                            suffixText: "%",
                            isDense: true,
                            isCollapsed: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'[\.,]')),
                            FilteringTextInputFormatter.allow(RegExp(r"^(100|[1-9][0-9]?)$")),
                          ],
                          onFieldSubmitted: (value) {
                            if (value.contains(",")) {
                              value = value.replaceFirst(",", ".");
                            }
                            context.read<Rubric>().latePercentagePerDay = double.parse(value);
                          },
                        ),
                        selector: (context, rubric) => rubric.latePercentagePerDay,
                      ),
                    ),
                  ),
                ),
                const Text("of"),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Selector<Rubric, String>(
                    builder: (context, latePolicy, child) {
                      return DropdownButton(
                        value: latePolicy,
                        isDense: true,
                        isExpanded: false,
                        items: const [
                          DropdownMenuItem<String>(value: "total", child: Text("total")),
                          DropdownMenuItem<String>(value: "earned", child: Text("earned")),
                        ],
                        onChanged: (String? s) {
                          if (s != null) {
                            context.read<Rubric>().latePolicy = s;
                          }
                        },
                      );
                    },
                    selector: (context, rubric) => rubric.latePolicy,
                  ),
                ),
                const Text("per day"),
              ]),
            ),
            const Text("Days late:"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 32,
                  child: Selector2<Rubric, GradedAssignment, Tuple2<double, double>>(
                    builder: (context, daysLateInfo, child) {
                      return SpinBox(
                        decoration: const InputDecoration(contentPadding: EdgeInsets.zero),
                        value: daysLateInfo.item1,
                        min: 0,
                        max: daysLateInfo.item2, // max is num days such that late penalty >= 100
                        onChanged: (value) => context.read<GradedAssignment>().daysLate = value.round(),
                      );
                    },
                    selector: (context, rubric, gradedAssignment) => Tuple2<double, double>(
                      gradedAssignment.daysLate.toDouble(),
                      rubric.maxDaysLate().toDouble(),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
