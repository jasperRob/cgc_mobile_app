import 'classes/game.dart';
import 'package:flutter/material.dart';

import 'classes/hole.dart';
import 'classes/score.dart';
import 'game_overview.dart';
import 're-usable/arrow_selection.dart';
import 'classes/graphql_utils.dart';
import 'classes/globals.dart' as globals;

class HoleView extends StatefulWidget {

  Game game;
  int index;
  int playerScore;

  HoleView({this.game, this.index});

  @override
  HoleViewState createState() => HoleViewState();
}

class HoleViewState extends State<HoleView> {

  void setScoreCallback(Object score) {
      widget.playerScore = score;
  }

  @override
  Widget build(BuildContext context) {


    if (widget.game.holes.elementAt(widget.index).scores == null) {
      widget.game.holes.elementAt(widget.index).scores = [];
    }
    Hole currentHole = widget.game.holes.elementAt(widget.index);

    // TODO: FIX THIS, MAKE SURE PREVIOUSLY SELECTED SCORE IS SHOWN
    widget.playerScore = currentHole.par;

    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(widget.game);
          },
        ),
        title: Text("Hole #" + currentHole.holeNum.toString()),
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
                  Text("Par  " + currentHole.par.toString(),
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
                itemIndex: currentHole.par-1, 
                callback: setScoreCallback
              ),
              SizedBox(height: 40,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  child: Text("Next",
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    // True will push next hole
                    await GraphQLUtils.submitScore(
                      widget.game.id, 
                      currentHole.id,
                      globals.user.id,
                      widget.playerScore
                      )
                    .catchError((error) {
                      print(error);
                    })
                    .then((value) {
                      // Create score object from data
                      Score score = new Score.fromJSON(value.data["submitScore"]["score"]);
                      // Add score to the hole
                      widget.game.holes.elementAt(widget.index).scores.add(score);
                    });
                    if (widget.index < widget.game.holes.length-1) {
                      setState(() {
                        widget.index += 1;
                      });
                    } else {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => GameOverview(game: widget.game)
                        )
                      );
                      
                      // Navigator.of(context).pop(widget.game);
                      // Navigator.of(context).pop();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}