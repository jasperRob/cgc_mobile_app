import 'classes/game.dart';
import 'classes/user.dart';
import 'hole_view.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'classes/globals.dart' as globals;
import 'classes/graphql_utils.dart';
import 'classes/hole.dart';
import 'game_page.dart';

class GameOverview extends StatelessWidget {

  Game game;
  String token;

  GameOverview({this.game});


  List<TableRow> createScoreTableRows() {
    List<TableRow> tableRows = [];

    List<Widget> playerNames = game.players.map<Widget>(
      (player) =>  Text(player.user.fullName())
    ).toList(); 
    playerNames.insert(0, Text(""));

    tableRows.add(new TableRow(children: playerNames));

    print("DID GET TO HERE");
    print(game.holes.length);
    game.holes.map((hole) {
      print(hole);
      List<Widget> scores = [];
      game.players.map((player) {
        print(player);
        scores.add(Text(hole.scores.where((score) => score.player.id == player.id).toString()));
      });
      scores.insert(0, Text(hole.holeNum.toString()));
      tableRows.add(new TableRow(children: scores));
    });

    return tableRows;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Text("Your Game Overview"),
              SizedBox(height: 30,),
              Row(
                children: <Widget>[
                  Expanded(flex: 15, child: Container(color: Colors.white,),),
                  Expanded(
                    flex: 70,
                    child: Table(
                      children: createScoreTableRows()
                    ),
                  ),
                  Expanded(flex: 15, child: Container(color: Colors.white,),),
                ],
              ),
              SizedBox(height: 60,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    await GraphQLUtils.finishGame(game.id)
                    .catchError((error) {
                      throw(error);
                    })
                    .then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop(game);
                      Navigator.of(context).pop();
                    });
                  },
                  child: Text("Finish Game",
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}