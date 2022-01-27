import 'package:flapp/menu.dart';
import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Options"),
        toolbarHeight: 50,
      ),
      drawer: const Menu(),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Text("Grading scale"),
          Text("Theme"),
          Text("Mode"),
          Text("Precision")
        ],
      ),
    );
  }
}
