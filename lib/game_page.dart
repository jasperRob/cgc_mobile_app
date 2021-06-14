import 'package:flutter/material.dart';

import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
// import 'hole_view.dart';
import 'hole_page.dart';

import 'utils.dart';

class GamePage extends StatefulWidget {

  Game game;
  GamePage({required this.game});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {

  @override
  void initState() {
    super.initState();
  }

  void nextHoleCallback(Hole hole) {
    print("NEXT HOLE CALLBACK");
    // TODO: Figure out a more efficient way of doing this
    Future<List<Hole>> hole_future = Utils.getHoles(widget.game.id);
    hole_future.then((holes) {
      for (Hole childHole in holes) {
        if (childHole.holeNum == hole.holeNum + 1) {
          // Pop Current Hole Page
          Navigator.of(context).pop();
          // Push Next Hole Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new HolePage(
                  hole: childHole,
                  game: widget.game,
                  nextHoleCallback: nextHoleCallback,
                  finishGameCallback: finishGameCallback
                  ),
            )
          );
          break;
        }
      }
    }).catchError((err){
      print("BIG ERROR FINDING NEXT HOLE: " + err);
    });
  }

  void finishGameCallback(Game game) {
    print("FINISH GAME CALLBACK");
    // TODO: Figure out a more efficient way of doing this
    Future<void> game_future = Utils.finishGame(widget.game);
    game_future.then((game) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }).catchError((err){
      print("BIG ERROR updating game: " + err);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Game Holes"),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: FutureBuilder<List<dynamic>>(
              future: Utils.getHoles(widget.game.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return snapshot.data.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return
                          Card(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text("Hole " + snapshot.data[index].holeNum.toString()),
                                  trailing: MaterialButton(
                                    child: Text("View"),
                                    onPressed: () {
                                      Hole hole = snapshot.data[index];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => new HolePage(
                                            hole: hole,
                                            game: widget.game,
                                            nextHoleCallback: nextHoleCallback,
                                            finishGameCallback: finishGameCallback
                                            ),
                                        )
                                      );
                                    }
                                  )
                                )
                              ],
                            ),
                          );
                      })
                    : Center(child: Text("No Friends to show"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      )
    );
  }

}
