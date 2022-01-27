import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class CategoriesSelector extends StatefulWidget {
  final int index;
  final String initLabel;
  final double initWeight;
  final bool autoFocus;
  final String saveText;
  final TextInputAction textInputAction;

  const CategoriesSelector.update(
      {Key? key,
      required this.index,
      required this.initLabel,
      required this.initWeight})
      : autoFocus = false,
        textInputAction = TextInputAction.go,
        saveText = "Save",
        super(key: key);

  const CategoriesSelector.add({Key? key})
      : index = -1,
        initLabel = "",
        initWeight = 0,
        autoFocus = true,
        textInputAction = TextInputAction.next,
        saveText = "Add",
        super(key: key);

  @override
  _CategoriesSelectorState createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends State<CategoriesSelector> {
  late String _label;
  late double _weight;
  late TextEditingController _controller;
  final _validationKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _label = widget.initLabel;
    _weight = widget.initWeight;
    _controller = TextEditingController(text: _label);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Wrap(
          children: [
            SizedBox(
              child: Form(
                key: _validationKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _controller,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r"\s\s")),
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[\$\\\{\}\[\]=]')),
                  ],
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  onChanged: (value) {
                    setState(() {
                      _label = value.trim();
                    });
                  },
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a category";
                    }
                    if (context
                        .read<Rubric>()
                        .isCategoryLabelUsed(widget.index, value.trim())) {
                      return "Category already entered";
                    }
                    return null;
                  },
                  focusNode: focus,
                  autofocus: widget.autoFocus,
                  decoration: const InputDecoration(
                    errorMaxLines: 3,
                    counterText: "",
                    filled: true,
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.red,
                        )),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Colors.red,
                      ),
                    ),
                    hintText: "Category name",
                  ),
                  textInputAction: widget.textInputAction,
                ),
              ),
            ),
            SpinBox(
                min: 0,
                max: 1000,
                step: 1,
                spacing: 0,
                direction: Axis.horizontal,
                value: _weight,
                onChanged: (value) {
                  setState(() {
                    _weight = value;
                  });
                })
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (_validationKey.currentState != null &&
                  _validationKey.currentState!.validate()) {
                if (widget.index != -1) {
                  context
                      .read<Rubric>()
                      .updateCategory(widget.index, _label, _weight);
                } else {
                  context.read<Rubric>().addCategory(_label, _weight);
                }
                Navigator.of(context).pop();
              } else {
                focus.requestFocus();
              }
            },
            child: Text(widget.saveText),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ]);
  }
}
