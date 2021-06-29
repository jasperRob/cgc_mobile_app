import 'package:flutter/material.dart';

import 'classes/user.dart';
import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
// import 'hole_view.dart';
import 'hole_page.dart';

import 'utils.dart';

class FinishedGamePage extends StatefulWidget {

  Game game;
  FinishedGamePage({required this.game});

  @override
  FinishedGamePageState createState() => FinishedGamePageState();
}

class FinishedGamePageState extends State<FinishedGamePage> {

  @override
  void initState() {
    super.initState();
  }


  List<TableRow> getScoreTableRows(Game game) {
    print("GETTING ROWS");

    List<Widget> headerRowWidgets = [Center(child: Text("Hole #"))];
    for (User player in game.players) {
      headerRowWidgets.add(Center(child: Text(player.fullName())));
    }
    List<TableRow> rows = [TableRow(children: headerRowWidgets)];

    // // Sort the holes by hole num
    // holes.sort((a, b) => a.holeNum.compareTo(b.holeNum));

    for (Hole hole in game.holes) {
      print("holeeeeeee");

      List<Widget> currentRow = [];
      currentRow.add(Center(child: Text("Hole " + hole.holeNum.toString())));

      for (User player in game.players) {
        print(player.fullName());
        String playerScore = "N/A";
        for (Score score in hole.scores) {
          // NOTE: THIS IS WRONG
          if (score.player.id == player.id) {
            print("ADDING SOMETHING TO ROWS");
            playerScore = score.value.toString();
          };
        }
        currentRow.add(Center(child: Text(playerScore)));
      }
      rows.add(TableRow(children: currentRow));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Finished Game"),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SizedBox(height: 80),
          Container(
            child: Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: getScoreTableRows(widget.game),
            ),
          ),
        ]
      )
    );
  }

}
