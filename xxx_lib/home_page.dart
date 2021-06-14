/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/game.dart';
import 'classes/globals.dart' as globals;
import 'game_page.dart';

class HomePage extends StatefulWidget {

  HomePage();

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  String token;
  static String userId = globals.user.id;

  final String activeGamesQueryString = """
  query {
    activeGamesByUserId(userId: \"$userId\") {
      id
      numHoles
      club {
        id
        name
        state
        country
      }
      players {
        edges {
          node {
            id
            user {
              id
              firstName
              lastName
            }
          }
        }
      }
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
                  holeId
                  player {
                    id
                  }
                  score
                }
              }
            }
          }
        }
      }
      created
    }
  }
  """;

  final String inactiveGamesQueryString = """
  query {
    inactiveGamesByUserId(userId: \"$userId\") {
      id
      numHoles
      club {
        id
        name
        state
      }
      created
    }
  }
  """;

  List<Function> refetchFuncs = new List(2);

  getToken() async {
    await globals.storage.read(key: "token")
    .then((value) {
      setState(() {
        token = "Bearer " + value;
      });
    });
  }

  runRefetchQueries() {
    for (Function refetch in refetchFuncs) {
      refetch();
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

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
            GraphQLProvider(
                child: Query(
                  options: QueryOptions(
                    documentNode: gql(activeGamesQueryString)
                  ),
                  builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                    refetchFuncs[0] = refetch;
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.loading) {
                      return Text("Loading");
                    }
                    final List<Game> games = <Game>[];

                    print(result.data);
                    for (var item in result.data["activeGamesByUserId"]) {
                      print(item);
                      games.add(Game.fromJSON(item));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        Game game = games[index];
                        return ListTile(
                          title: Text(game.club.name),
                          subtitle: Text(game.numHoles.toString() + " Holes \n" + game.created),
                          isThreeLine: true,
                          onTap: () async {
                            await Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => GamePage(game: game),
                              )
                            ).then((value) => {
                              runRefetchQueries()
                            });
                          },
                        );
                      },
                    );
                  },
                // ),
              ),
              client: ValueNotifier(
                GraphQLClient(
                  cache: InMemoryCache(),
                  link: HttpLink(
                    uri: globals.uri,
                    headers: {
                      "Authorization": token
                    }
                  )
                )
              )
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text("Previous Games")
            ),
            GraphQLProvider(
                child: Query(
                  options: QueryOptions(
                    documentNode: gql(inactiveGamesQueryString)
                  ),
                  builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                    refetchFuncs[1] = refetch;
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.loading) {
                      return Text("Loading");
                    }
                    final List<Game> games = <Game>[];

                    // print(result.data);
                    for (var item in result.data["inactiveGamesByUserId"]) {
                      print(item);
                      games.add(Game.fromJSON(item));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        Game game = games[index];
                        return ListTile(
                          title: Text(game.club.name),
                          subtitle: Text(game.numHoles.toString() + " Holes \n" + game.created),
                          isThreeLine: true,
                        );
                      },
                    );
                  },
                // ),
              ),
              client: ValueNotifier(
                GraphQLClient(
                  cache: InMemoryCache(),
                  link: HttpLink(
                    uri: globals.uri,
                    headers: {
                      "Authorization": token
                    }
                  )
                )
              )
            )
          ],
        ),
      ),
    );
  }
}
