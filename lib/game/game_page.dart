import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


Future<dynamic> finishGame(Game game) async {

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.UPDATE_GAME),
    variables: {
      "updateGameGameId": game.id.hexString,
      "updateGameEnded": true,
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);
}

class GamePage extends StatefulWidget {

  Game game;
  GamePage({required this.game});

  @override
  GamePageState createState() => GamePageState(this.game);
}

class GamePageState extends State<GamePage> {

  Game game;
  GamePageState(this.game);

  @override
  void initState() {
    super.initState();
  }

  void nextHoleCallback(Hole hole, Score score) {
    print("NEXT HOLE CALLBACK");
    // TODO: Figure out a more efficient way of doing this
    for (Hole childHole in game.holes) {
      if (childHole.holeNum == hole.holeNum + 1) {
        // Pop Current Hole Page
        Navigator.of(context).pop();
        // Push Next Hole Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => new HolePage(
                hole: childHole,
                game: game,
                nextHoleCallback: nextHoleCallback,
                finishGameCallback: finishGameCallback
                ),
          )
        );
        break;
      }
    }
  }

  void finishGameCallback(Game game) {
    print("FINISH GAME CALLBACK");
    // TODO: Figure out a more efficient way of doing this
    Future<void> game_future = finishGame(game);
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
      body: Query(
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
              // return Text('Loading');
              return LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: const [Colors.grey],
                strokeWidth: 2,
              );
            }

            Game game = Game.fromJSON(result.data!["node"]);
            List holes = game.holes;

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: (holes.length+1),
              itemBuilder: (context, index) {

                if (index < holes.length) {
                  Hole hole = holes[index];
                  double adjusted = Utils.adjustedDistance(hole.distance, hole.holeNum, game.club.windStrength, globals.user.handicap);
                  bool unavailable = (hole.holeNum > 1 && hole.scores.length == 0);

                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Text(hole.holeNum.toString(),
                            style: TextStyle(fontSize: 20.0, 
                              color: unavailable ? Colors.grey.shade300 : null
                            ),
                          ),
                          title: Text("Par " + hole.par.toString(),
                            style: unavailable ? TextStyle(color: Colors.grey.shade300) : null
                          ),
                          subtitle: Text("" + hole.distance.toString() + "m  -  Adjusted: " + adjusted.toStringAsFixed(1) + "m",
                            style: unavailable ? TextStyle(color: Colors.grey.shade300) : null
                          ),
                          trailing: Icon(Icons.reorder),
                          onTap: unavailable ? null : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => new HolePage(
                                  hole: hole,
                                  game: game,
                                  nextHoleCallback: nextHoleCallback,
                                  finishGameCallback: finishGameCallback
                                ),
                              )
                            ).then((_) => setState(() {}));
                          }
                        )
                      ],
                    ),
                  );
                } else {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text("Total Par: " + game.totalPar().toString()),
                          subtitle: Text("Total Distance: " + game.totalDistance().toString() + "m"),
                        )
                      ]
                    )
                  );
                }
              }
            );
          }
        )
      );
    }

}
