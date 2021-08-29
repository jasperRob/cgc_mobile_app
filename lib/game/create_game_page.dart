/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


Future<dynamic> createGame(Club club, int numHoles, List<User> players) async {


  List playerIds = new List<String>.from(players.map((item) {
    return item.id.hexString;
  }));

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.CREATE_GAME),
    variables: {
      "createGameClubId": club.id.hexString,
      "createGameNumHoles": numHoles,
      "createGamePlayerIds": playerIds,
      "createGameEnded": false
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);

  print(result.exception.toString());
  print(result.data);
  return result.data["createGame"];
}

class CreateGamePage extends StatefulWidget {

  @override
  CreateGameState createState() => CreateGameState();
}

class CreateGameState extends State<CreateGamePage> {

  int gameTypeIndex = 1;
  int maxNumPlayers = 4;

  int holeNum = 9;
  int numMinutes = 60;

  // List<String> players = ["","","",""];
  List<User> players = [globals.user];

  void invitePlayerCallback(User user) {
    List<User> playerList = players;
    playerList.add(user);
    setState(() {
      players = playerList;
    });
    // Only shift if a user has been removed
  }

  void setNumHolesCallback(int value) {
    setState(() {
      holeNum = value;
    });
  }

  void setNumMinutesCallback(int value) {
    setState(() {
      numMinutes = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Create our player selectors
    final playerWidgets = <Widget>[];
    for (int i = 0; i < players.length; i++) {
      User player = players[i];

      playerWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Text("Player " + (i+1).toString()),
            SizedBox(width: 20,),
            Text(player.fullName(),
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(width: 20,),
          ],
        )
      );
    }
    if (players.length < maxNumPlayers) {
      playerWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Player " + (players.length+1).toString()),
            SizedBox(width: 20,),
            MaterialButton(
              child: Icon(Icons.add),
              onPressed: () {
                print("ADD PRESSED");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new InvitePage(selected: players, callback: invitePlayerCallback),
                  )
                ).then((_) => setState(() {}));
              },
            ),
            SizedBox(width: 20,),
          ],
        )
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 70,),
              Center(
                child: Row(children: [
                  Text("Club: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(globals.user.club.name),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20,),
              Center(
                child: Row(children: [
                  Text("Wind Direction: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(Utils.orNA(globals.user.club.windDirection)),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 50,),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     MaterialButton(
              //       child: Text("Standard"),
              //       textColor: gameTypeIndex==0 ? Colors.black : Colors.grey,
              //       onPressed: () {
              //         setState(() {
              //           gameTypeIndex = 0;
              //         });
              //       },
              //     ),
              //     SizedBox(width: 50,),
              //     MaterialButton(
              //       child: Text("Custom"),
              //       textColor: gameTypeIndex==1 ? Colors.black : Colors.grey,
              //       onPressed: () {
              //         setState(() {
              //           gameTypeIndex = 1;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              // SizedBox(height: 10,),
              Center(
                child: gameTypeIndex == 0
                  ? StandardGameOptions(holeNum: holeNum, setNumHolesCallback: setNumHolesCallback) 
                  : CustomGameOptions(holeNum: holeNum, setNumHolesCallback: setNumHolesCallback, setNumMinutesCallback: setNumMinutesCallback),
              ),
              SizedBox(height: 60,),
              Container(
              constraints: BoxConstraints(minHeight: 0, maxHeight: 250),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: playerWidgets.length,
                    itemBuilder: (context, index) {
                      return playerWidgets.elementAt(index);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: Material(
                  elevation: 5.0,
                  borderRadius: globals.radius,
                  color: globals.primaryDarkColor,
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      dynamic gameData = await createGame(globals.user.club, holeNum, players);

                      Game newGame = Game.fromJSON(gameData["game"]);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => new GamePage(game: newGame),
                        )
                      ).then((_) => setState(() {}));
                    },
                    child: Text("Start Game",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: globals.primaryLightColor
                      )
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StandardGameOptions extends StatefulWidget {

  int holeNum;
  Function(int) setNumHolesCallback;

  StandardGameOptions({required this.holeNum, required this.setNumHolesCallback});

  @override
  StandardGameOptionsState createState() => StandardGameOptionsState();
}

class StandardGameOptionsState extends State<StandardGameOptions> {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        Text("Number of Holes"),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text("9"),
              textColor: widget.holeNum==9 ? Colors.black : Colors.grey,
              onPressed: () {
                widget.setNumHolesCallback(9);
              }
            ),
            SizedBox(width: 20,),
            MaterialButton(
              child: Text("18"),
              textColor: widget.holeNum==18 ? Colors.black : Colors.grey,
              onPressed: () {
                widget.setNumHolesCallback(18);
              }
            ),
          ],
        ),
      ],
    );
  }
}

class CustomGameOptions extends StatefulWidget {

  int holeNum;
  Function(int) setNumHolesCallback;
  Function(int) setNumMinutesCallback;

  CustomGameOptions({required this.holeNum, required this.setNumHolesCallback, required this.setNumMinutesCallback});

  @override
  CustomGameOptionsState createState() => CustomGameOptionsState();
}

class CustomGameOptionsState extends State<CustomGameOptions> {

  @override
  Widget build(BuildContext context) {

    final numHolesField = ArrowSelection(
      title: "", 
      items: [for(var i=1; i<19; i+=1) i], 
      itemIndex: 8, 
      callback: widget.setNumHolesCallback
    );

    final numMinsField = ArrowSelection(
      title: "", 
      items: [for(var i=15; i<180; i+=15) i], 
      itemIndex: 0, 
      callback: widget.setNumMinutesCallback
    );

    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        Text("Number of Holes"),
        SizedBox(height: 20,),
        numHolesField,
        SizedBox(height: 10,),
        // Text("Number of Minutes"),
        // SizedBox(height: 20,),
        // numMinsField
      ],
    );
  }
}
