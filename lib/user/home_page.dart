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
import 'package:location/location.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;

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
    String dateString = getSimpleDate(game.created);
    return Text(dateString + " - " + game.numHoles.toString() + " Holes - " + game.club.name,
      style: TextStyle(
        fontSize: 16
      ),
    );
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
                    document: gql(Queries.GET_ACTIVE_GAMES),
                    variables: {
                      "userId": globals.user.id.hexString,
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

                  print("ACTIVE GAMES = ");
                  print(result.data);
                  // it can be either Map or List
                  // List games = result.data!['allGames']['edges'];
                  List games = result.data!['activeGamesByUserId'];

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      // Game game = Game.fromJSON(games[index]["node"]);
                      Game game = Game.fromJSON(games[index]);

                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(game.numHoles.toString() + " Holes"),
                              subtitle: Text(game.club.name.toString() + "\n" + getSimpleDate(game.created)),
                              isThreeLine: true,
                              trailing: Icon(Icons.reorder),
                              // title: getGameTitle(game),
                              onTap: () {
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
                              // trailing: MaterialButton(
                              //   child: Text("View"),
                              // )
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
                    document: gql(Queries.GET_ENDED_GAMES),
                    variables: {
                      "userId": globals.user.id.hexString,
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

                  // it can be either Map or List
                  List games = result.data!['endedGamesByUserId'];

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      Game game = Game.fromJSON(games[index]);

                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(game.numHoles.toString() + " Holes"),
                              subtitle: Text(game.club.name.toString() + "\n" + getSimpleDate(game.created)),
                              isThreeLine: true,
                              // title: getGameTitle(game),
                              onTap: () {
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
                              // 
                              // title: getGameTitle(game),
                              // trailing: MaterialButton(
                              //   child: Text("View"),
                              // )
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
