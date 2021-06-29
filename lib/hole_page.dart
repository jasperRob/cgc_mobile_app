import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/user.dart';
import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
import 'utils.dart';

Future<dynamic> submitScore(Hole hole, User player, int value) async {

  const CREATE_SCORE = """
  mutation Mutations(\$createScoreHoleId: String!, \$createScorePlayerId: String!, \$createScoreValue: Int!) {
    createScore(holeId: \$createScoreHoleId, playerId: \$createScorePlayerId, value: \$createScoreValue) {
      ok
      score {
        id
        player {
          id
        }
        value
      }
    }
  }
  """;

  print("VALUE: " + value.toString());
  MutationOptions mutationOptions = MutationOptions(
    document: gql(CREATE_SCORE),
    variables: {
      "createScoreHoleId": hole.id,
      "createScorePlayerId": player.id,
      "createScoreValue": value
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);
  return result.data["createScore"];
}

class HolePage extends StatefulWidget {

  Hole hole;
  Game game;
  Function(Hole, Score) nextHoleCallback;
  Function(Game) finishGameCallback;

  HolePage({required this.hole, required this.game, required this.nextHoleCallback, required this.finishGameCallback});

  @override
  HolePageState createState() => HolePageState(this.hole.par);

}

class HolePageState extends State<HolePage> {

  int score;

  HolePageState(this.score);

  @override
  Widget build(BuildContext context) {

  void setScoreCallback(int value) {
    setState(() {
      this.score = value;
    });
  }

    // TODO: FIX THIS, MAKE SURE PREVIOUSLY SELECTED SCORE IS SHOWN

    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Hole #" + widget.hole.holeNum.toString()),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Par  " + widget.hole.par.toString(),
                  style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 40,),
              ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 200,
                  minWidth: MediaQuery.of(context).size.width*0.75,
                ),
                child: new DecoratedBox(
                  child: Text("MAP"),
                  decoration: new BoxDecoration(color: Colors.grey),
                ),
              ),
              SizedBox(height: 40,),
              ArrowSelection(
                title: "Your Score: ", 
                items: [for(var i=1; i<50; i+=1) i], 
                itemIndex: widget.hole.par-1, 
                callback: setScoreCallback
              ),
              SizedBox(height: 40,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  child: (widget.game.numHoles == widget.hole.holeNum) ? Text("Finish") : Text("Submit Score",
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    dynamic data = await submitScore(widget.hole, globals.user, score);
                    Score newScore = Score.fromJSON(data["score"]);
                    if (widget.game.numHoles == widget.hole.holeNum) {
                      widget.finishGameCallback(widget.game);
                    } else {
                      widget.nextHoleCallback(widget.hole, newScore);
                    }
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
