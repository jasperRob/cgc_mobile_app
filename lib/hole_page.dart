import 'package:flutter/material.dart';

import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
import 'utils.dart';

class HolePage extends StatefulWidget {

  Hole hole;
  Game game;
  Function(Hole) nextHoleCallback;
  Function(Game) finishGameCallback;

  HolePage({required this.hole, required this.game, required this.nextHoleCallback, required this.finishGameCallback});

  @override
  HolePageState createState() => HolePageState();

}

class HolePageState extends State<HolePage> {

  int score = 0;

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
                  child: (widget.game.numHoles == widget.hole.holeNum) ? Text("Finish") : Text("Next",
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Utils.postScore(widget.hole.id, globals.user.id, score);
                    if (widget.game.numHoles == widget.hole.holeNum) {
                      widget.finishGameCallback(widget.game);
                    } else {
                      widget.nextHoleCallback(widget.hole);
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
