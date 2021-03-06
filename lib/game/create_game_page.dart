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


Future<dynamic> createGame(Club club, int numMinutes, List<User> players) async {


  List playerIds = new List<String>.from(players.map((item) {
    return item.id.hexString;
  }));

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.CREATE_GAME),
    variables: {
      "createGameClubId": club.id.hexString,
      "createGameNumMinutes": numMinutes,
      "createGamePlayerIds": playerIds,
      "createGameEnded": false,
      "createGameWindStrength": 0.2,
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

    // print("PLAYERS");
    // print(players);

    // for (User user in players) {
    //   print(user.fullName());
    // }
    // Create our player selectors
    final playerWidgets = <Widget>[];
    for (int i = 0; i < players.length; i++) {
      User player = players[i];

      playerWidgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Text("Player " + (i+1).toString()),
              ),
              // Flexible(
              //   flex: 1,
              //   child: Spacer(),
              // ),
              SizedBox(width: 10),
              Flexible(
                flex: 1,
                // Spacer(),
                child: Text(player.fullName(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                ),
              ),
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
              Flexible(
                flex: 1,
                child: Text("Player " + (players.length+1).toString()),
              ),
              // Flexible(
              //   flex: 1,
              //   child: Spacer(),
              // ),
              SizedBox(width: 10),
              Flexible(
                flex: 1,
                child: MaterialButton(
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
              ),
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
              Spacer(),
              Flexible(
                flex: 1,
                child: Center(
                  child: Row(children: [
                    Text("Club: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                    )),
                    // SizedBox(width: 20),
                    Text(globals.user.club.name),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center
                  )
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Row(children: [
                    Text("Wind Direction: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                    )),
                    Text(Utils.orNA(globals.user.club.windDirection)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center
                  )
                ),
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: Row(children: [
                    Text("Wind Strength: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                    )),
                    Text(Utils.orNADouble(globals.user.club.windStrength)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center
                  )
                ),
              ),
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

              Flexible(
                flex: 5,
                child: Center(
                  child: gameTypeIndex == 0
                    ? StandardGameOptions(holeNum: holeNum, setNumHolesCallback: setNumHolesCallback) 
                    : CustomGameOptions(holeNum: holeNum, setNumHolesCallback: setNumHolesCallback, setNumMinutesCallback: setNumMinutesCallback),
                ),
              ),
              Flexible(
                flex: 7,
                child: ListView.builder(
                  itemCount: playerWidgets.length,
                  itemBuilder: (context, index) {
                    return playerWidgets.elementAt(index);
                  },
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: globals.radius,
                    color: globals.primaryDarkColor,
                    child: MaterialButton(
                      // minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async {
                        dynamic gameData = await createGame(globals.user.club, numMinutes, players);

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
              ),
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
        // SizedBox(height: 30,),
        Text("Number of Holes"),
        // SizedBox(height: 20,),
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
      items: [for(var i=10; i<=300; i+=10) i], 
      itemIndex: 0, 
      callback: widget.setNumMinutesCallback
    );

    return Column(
      children: <Widget>[
        SizedBox(height: 30,),
        // Text("Number of Holes"),
        Text("Minutes to play"),
        SizedBox(height: 20,),
        // numHolesField,
        numMinsField,
        SizedBox(height: 10,),
        // Text("Number of Minutes"),
        // SizedBox(height: 20,),
      ],
    );
  }
}
