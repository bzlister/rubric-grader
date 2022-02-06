import 'package:flapp/menu.dart';
import 'package:flapp/routes/options/components/grading_scale_option.dart';
import 'package:flapp/routes/options/components/score_selection_option.dart';
import 'package:flapp/routes/options/components/theme_option.dart';
import 'package:flapp/routes/options/option_group.dart';
import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Options"),
        toolbarHeight: 50,
      ),
      drawer: const Menu(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            OptionGroup(
              optionsList: [
                ScoreSelectionOption(),
                GradingScaleOption(),
              ],
            ),
            OptionGroup(optionsList: [ThemeOption()]),
          ],
        ),
      ),
    );
  }
}
