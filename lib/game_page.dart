import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
import 'classes/queries.dart';
// import 'hole_view.dart';
import 'hole_page.dart';

import 'utils.dart';

Future<dynamic> finishGame(Game game) async {

  const UPDATE_GAME = """
  mutation Mutations(\$updateGameGameId: String!, \$updateGameActive: Boolean) {
    updateGame(gameId: \$updateGameGameId, active: \$updateGameActive) {
      game {
        id
      }
    }
  }
  """;

  MutationOptions mutationOptions = MutationOptions(
    document: gql(UPDATE_GAME),
    variables: {
      "updateGameGameId": game.id,
      "updateGameActive": false,
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
    print(game);
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
      body: Column(
        children: <Widget>[
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
                  List holes = game.holes;

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: holes.length,
                    itemBuilder: (context, index) {
                      Hole hole = holes[index];
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text("Hole " + hole.holeNum.toString()),
                              trailing: MaterialButton(
                                child: Text("View"),
                                onPressed: (hole.holeNum > 1 && hole.scores.length == 0) ? null : () {
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
                            )
                          ],
                        ),
                      );
                  });
                },
              )
            ),
        ],
      )
    );
  }

}
