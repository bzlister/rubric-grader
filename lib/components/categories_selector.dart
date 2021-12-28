import 'package:flapp/models/rubric.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:provider/provider.dart';

class CategoriesSelector extends StatefulWidget {
  final int index;
  final Factor category;
  final bool autoFocus;
  final TextInputAction textInputAction;

  const CategoriesSelector.update(
      {Key? key, required this.index, required this.category})
      : autoFocus = false,
        textInputAction = TextInputAction.go,
        super(key: key);

  CategoriesSelector.add({Key? key})
      : index = -1,
        category = Factor("", 0),
        autoFocus = true,
        textInputAction = TextInputAction.next,
        super(key: key);

  @override
  _CategoriesSelectorState createState() => _CategoriesSelectorState();
}

class _CategoriesSelectorState extends State<CategoriesSelector> {
  late Factor _category;
  late TextEditingController _controller;
  final _validationKey = GlobalKey<FormState>();
  final FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _category = Factor(widget.category.label, widget.category.weight);
    _controller = TextEditingController(text: _category.label);
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
                      _category.label = value;
                    });
                  },
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a category";
                    }
                    if (context.read<Rubric>().isCategoryLabelUsed(value)) {
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
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                        color: Color(0xffE5E5E5),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
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
                value: _category.weight,
                onChanged: (value) {
                  setState(() {
                    _category.weight = value;
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
                      .updateCategory(widget.index, _category);
                } else {
                  context.read<Rubric>().addCategory(_category);
                }
                Navigator.of(context).pop();
              } else {
                focus.requestFocus();
              }
            },
            child: const Text('Save'),
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
