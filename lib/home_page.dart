/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/globals.dart' as globals;
import 'classes/game.dart';
import 'game_page.dart';
import 'finished_game_page.dart';
import 'utils.dart';

const GET_ALL_GAMES = '''
query Query(\$allGamesActive: Boolean) {
  allGames(active: \$allGamesActive) {
    edges {
      node {
        id
        numHoles
        active
        holes {
          edges {
            node {
              id
              holeNum
              par
              scores {
                edges {
                  node {
                    id
                    value
                    player {
                      id
                      firstName
                      lastName
                    }
                  }
                }
              }
            }
          }
        }
        players {
          edges {
            node {
              id
              firstName
              lastName
            }
          }
        }
      }
    }
  }
}
''';

class HomePage extends StatefulWidget {

  HomePage();

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  String getSimpleDate(DateTime dt) {
    var dateFormat = DateFormat("yy/MM/dd");
    String date = dateFormat.format(dt);
    return date;
  }

  Widget getGameTitle(Game game) {
    String dateString = getSimpleDate(dateFormat.parse(game.getCreated()));
    return Text(dateString + " - " + game.numHoles.toString() +  " Holes");
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text("Active Games")
            ),
            Container(
              child: Query(
                options: QueryOptions(
                    document: gql(GET_ALL_GAMES),
                    variables: {
                      "allGamesActive": true
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

                  // it can be either Map or List
                  List games = result.data!['allGames']['edges'];

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      Game game = Game.fromJSON(games[index]["node"]);

                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(game.id),
                              trailing: MaterialButton(
                                child: Text("View"),
                                onPressed: () {
                                  print("PRESSED");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new GamePage(
                                        game: game,
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
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text("Previous Games")
            ),
            Container(
              child: Query(
                options: QueryOptions(
                    document: gql(GET_ALL_GAMES),
                    variables: {
                      "allGamesActive": false
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

                  // it can be either Map or List
                  List games = result.data!['allGames']['edges'];

                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      Game game = Game.fromJSON(games[index]["node"]);

                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(game.id),
                              trailing: MaterialButton(
                                child: Text("View"),
                                onPressed: () {
                                  print("PRESSED");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new FinishedGamePage(
                                        game: game,
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
        ),
      ),
    );
  }
}
