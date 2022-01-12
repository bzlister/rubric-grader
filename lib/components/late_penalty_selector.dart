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
    return Column(
      children: [
        Row(children: [
          const Text("Late penalty:"),
          SizedBox(
            width: 60,
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Selector<Rubric, double>(
                builder: (context, latePercentagePerDay, child) =>
                    TextFormField(
                  controller: TextEditingController(
                      text: latePercentagePerDay.toStringAsFixed(0)),
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.go,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      const InputDecoration(prefixText: "-", suffixText: "%"),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[\.,]')),
                    FilteringTextInputFormatter.allow(
                        RegExp(r"^(100|[1-9][0-9]?)$")),
                  ],
                  onFieldSubmitted: (value) {
                    if (value.contains(",")) {
                      value = value.replaceFirst(",", ".");
                    }
                    context.read<Rubric>().latePercentagePerDay =
                        double.parse(value);
                  },
                ),
                selector: (context, rubric) => rubric.latePercentagePerDay,
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
                  items: const [
                    DropdownMenuItem<String>(
                        value: "total", child: Text("total")),
                    DropdownMenuItem<String>(
                        value: "earned", child: Text("earned")),
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
        Row(
          children: [
            const Text("Days late:"),
            Selector<Rubric, Tuple2<double, double>>(
                builder: (context, daysLateInfo, child) => SizedBox(
                      width: 120,
                      child: SpinBox(
                        value: daysLateInfo.item1,
                        min: 0,
                        max: daysLateInfo
                            .item2, // max is num days such that late penalty >= 100
                        onChanged: (value) =>
                            context.read<Rubric>().daysLate = value.round(),
                      ),
                    ),
                selector: (context, rubric) => Tuple2<double, double>(
                    rubric.daysLate.toDouble(),
                    rubric.maxDaysLate().toDouble())),
          ],
        )
      ],
    );
  }
}
