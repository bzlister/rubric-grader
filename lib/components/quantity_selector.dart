import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';

class QuantitySelector extends StatelessWidget {
  final void Function(double)? onChanged;

  const QuantitySelector({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Popup example'),
      content: SpinBox(
        min: 0,
        max: 100,
        value: 75,
        onChanged: onChanged,
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
