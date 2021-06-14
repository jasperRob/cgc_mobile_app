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

  Future<List<dynamic>> fetchAllTableData(Game game) async {

    // TODO: Get Game Player
    List<User> players = await Utils.getPlayers(game.id);
    List<Hole> holes = await Utils.getHoles(game.id);
    List<Score> scores = await Utils.getAllScores(game.id);
    List<dynamic> dataTuple = [players, holes, scores];
    return dataTuple;
  }

  List<TableRow> getScoreTableRows(Game game, List<User> players, List<Hole> holes, List<Score> scores) {

    List<Widget> headerRowWidgets = [Center(child: Text("Hole #"))];
    for (User player in players) {
      headerRowWidgets.add(Center(child: Text(player.fullName())));
    }
    List<TableRow> rows = [TableRow(children: headerRowWidgets)];
    print("SCore Length: " + scores.length.toString());

    // Sort the holes by hole num
    holes.sort((a, b) => a.holeNum.compareTo(b.holeNum));

    for (Hole hole in holes) {

      List<Widget> currentRow = [];
      currentRow.add(Center(child: Text("Hole " + hole.holeNum.toString())));

      for (User player in players) {
        String playerScore = "N/A";
        for (Score score in scores) {
          print(score.userId + " = " + player.id + " --- " +score.holeId + " = " + hole.id);
          if (score.userId == player.id && score.holeId == hole.id) {
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
            child: FutureBuilder(
              future: fetchAllTableData(widget.game),
              builder: (context, snapshot) {
                print(snapshot.data);
                if(!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if(snapshot.hasData) {
                  dynamic data = snapshot.data;
                  return Table(
                    border: TableBorder.all(),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: getScoreTableRows(widget.game, data[0], data[1], data[2]),

                  );
                }
                return Center();
              },
            ),
          ),
        ]
      )
    );
  }

}
