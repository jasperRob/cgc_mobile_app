import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


class FinishedGamePage extends StatefulWidget {

  Game game;
  FinishedGamePage({required this.game});

  @override
  FinishedGamePageState createState() => FinishedGamePageState(this.game);
}


class FinishedGamePageState extends State<FinishedGamePage> {

  Game game;
  FinishedGamePageState(this.game);

  @override
  void initState() {
    super.initState();
  }

  Widget tableCellOf(Widget widget) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: widget)
      );
  }


  List<TableRow> getScoreTableRows(Game game) {
    print("GETTING ROWS");

    const fontFamily = "Montserrat";
    final boldStyle = TextStyle(fontWeight: FontWeight.bold, fontFamily: fontFamily);
    final style = TextStyle(fontFamily: fontFamily);

    List<Widget> headerRowWidgets = [
      tableCellOf(Text("Hole #", style: boldStyle)),
      tableCellOf(Text("Par", style: boldStyle)),
      tableCellOf(Text("Distance", style: boldStyle)),
    ];
    for (User player in game.players) {
      headerRowWidgets.add(tableCellOf(Text(player.fullName(), style: boldStyle)));
    }
    List<TableRow> rows = [TableRow(children: headerRowWidgets)];

    // // Sort the holes by hole num
    // holes.sort((a, b) => a.holeNum.compareTo(b.holeNum));
    List<int> totals = List<int>.generate(game.players.length, (int index) => 0);

    for (Hole hole in game.holes) {

      List<Widget> currentRow = [];
      currentRow.add(tableCellOf(Text("Hole " + hole.holeNum.toString(), style: style)));
      currentRow.add(tableCellOf(Text(Utils.orNAInt(hole.par), style: style)));
      currentRow.add(tableCellOf(Text(Utils.orNAInt(hole.distance) + "m", style: style)));

      int playerCount = 0;
      for (User player in game.players) {
        print(player.fullName());
        String playerScore = "N/A";
        for (Score score in hole.scores) {
          if (score.player.id == player.id) {
            playerScore = score.value.toString();
            totals[playerCount] += score.value;
          };
        }
        currentRow.add(tableCellOf(Text(playerScore)));
        playerCount += 1;
      }
      rows.add(TableRow(children: currentRow));
    }

    List<Widget> totalScoreWidgets = [
      tableCellOf(Text("Total:", style: boldStyle)),
      tableCellOf(Text(game.totalPar().toString(), style: style)),
      tableCellOf(Text(game.totalDistance().toString()+"m", style: style))
    ];

    for (int total in totals) {
      totalScoreWidgets.add(tableCellOf(Text(total.toString())));
    }

    rows.add(TableRow(children: totalScoreWidgets));

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
            child: Query(
              options: QueryOptions(
                  document: gql(Queries.GET_GAME),
                  variables: {
                    "nodeId": game.graphqlID()
                  },
                  pollInterval: Duration(seconds: 10),
              ),
              builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
                if (result.hasException) {
                    return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return Text('Loading');
                }

                print(result.data!["node"]);
                Game game = Game.fromJSON(result.data!["node"]);

                return Table(
                  border: TableBorder.all(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(4.0)),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: getScoreTableRows(game),
                );

                // return Column(
                //   children: <Widget>[
                //     Table(
                //       border: TableBorder.all(),
                //       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //       children: getScoreTableRows(game),
                //     ),
                //     SizedBox(height: 10),
                //     Table(
                //       border: TableBorder.all(),
                //       defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                //       children: getScoreTotalRow(game),
                //     ),
                //   ]
                // );
              },
            )
          ),
        ]
      )
    );
  }

}
