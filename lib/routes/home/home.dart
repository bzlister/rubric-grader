import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flapp/menu.dart';
import 'package:flapp/models/grader.dart';
import 'package:flapp/routes/home/saved_rubric_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GlobalKey<ExpansionTileCardState>> cardKeyList = [];
    return Scaffold(
      appBar: AppBar(title: const Text("Rubric Grader")),
      drawer: const Menu(),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 5.0, left: 1, right: 1, bottom: 1),
        child: SingleChildScrollView(
          child: Selector<Grader, Grader>(
            builder: (context, grader, child) => Column(
              children: List.generate(
                grader.savedRubrics.length,
                (index) {
                  cardKeyList.add(GlobalKey());
                  return SavedRubricCard(
                    grader: grader,
                    rubric: grader.savedRubrics[index],
                    tileKey: cardKeyList[index],
                    onExpansionChanged: (opened) {
                      if (opened) {
                        for (int i = 0; i < grader.savedRubrics.length; i++) {
                          if (index != i) {
                            cardKeyList[i].currentState?.collapse();
                          }
                        }
                      }
                    },
                  );
                },
              ),
            ),
            selector: (context, grader) => grader,
          ),
        ),
      ),
    );
  }
}
