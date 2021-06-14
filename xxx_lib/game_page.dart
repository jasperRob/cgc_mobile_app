import 'classes/game.dart';
import 'package:flutter/material.dart';

import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/graphql_utils.dart';
import 'classes/globals.dart' as globals;
import 'hole_view.dart';

class GamePage extends StatefulWidget {

  Game game;
  GamePage({this.game});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {

  @override
  void initState() {
    super.initState();
    initHoleScores();
  }

  void initHoleScores() {
    for (int i = widget.game.holes.length-1; i > 0; i--) {
      if (i > 0 && widget.game.holes.elementAt(i).scores == null && widget.game.holes.elementAt(i-1).scores != null) {
        widget.game.holes.elementAt(i).scores = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // Ensure first hole is initialized
    for (Hole hole in widget.game.holes) {
      if (hole.holeNum == 1) {
        if (hole.scores == null) {
          hole.scores = [];
        }
      }
    }

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
          child: ListView.builder(
            itemCount: widget.game.holes.length,
            itemBuilder: (context, index) {
              bool isDisabled = true;
              Hole elem = widget.game.holes.elementAt(index);
              // If hole has scores attached or hole is first
              if ( elem.scores != null || elem.holeNum == 1) {
                isDisabled = false;
              }
              return ListTile(
                title: Text("Hole #" + elem.holeNum.toString()),
                enabled: isDisabled ? false : true,
                onTap: isDisabled ? null : () async {
                  await Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => HoleView(game: widget.game, index: index)
                    )
                  )
                  .catchError((error) {
                    print(error);
                  })
                  .then((game) {
                    setState(() {
                      widget.game = game;
                    });
                  });
                },
              );
            },
          )
        ),
      ),
    );
  }

}