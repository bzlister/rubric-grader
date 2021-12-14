import 'package:flutter/material.dart';

class RubricButton extends StatefulWidget {
  const RubricButton(
      {Key? key, required this.activatedText, required this.callback})
      : super(key: key);

  final String activatedText;
  final Function callback;

  @override
  State<RubricButton> createState() => _RubricButtonState();
}

class _RubricButtonState extends State<RubricButton> {
  bool _selected = false;

  void _onClick() => setState(() {
        widget.callback();
        _selected = true;
      });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _onClick,
      child: Text(
        _selected ? widget.activatedText : "-",
        style: _selected
            ? const TextStyle(
                color: Colors.white10, backgroundColor: Colors.blue)
            : const TextStyle(color: Colors.blueGrey),
      ),
    );
  }
}
