/* 
The contents of the common page body 
when home page is the active state
*/
import 're-usable/arrow_selection.dart';
import 'package:flutter/material.dart';

import 'classes/globals.dart' as globals;
import 'classes/user.dart';
import 'classes/game.dart';

import 'utils.dart';
import 'common.dart';
import 'invite_page.dart';
import 'game_page.dart';

class CreateGamePage extends StatefulWidget {

  @override
  CreateGameState createState() => CreateGameState();
}

class CreateGameState extends State<CreateGamePage> {

  int gameTypeIndex = 0;
  int maxNumPlayers = 4;

  int holeNum = 9;

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

  void setHoleNumCallback(int value) {
    setState(() {
      holeNum = value;
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
                );
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
              SizedBox(height: 30,),
              Text("Game Type"),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text("Standard"),
                    textColor: gameTypeIndex==0 ? Colors.black : Colors.grey,
                    onPressed: () {
                      setState(() {
                        gameTypeIndex = 0;
                      });
                    },
                  ),
                  SizedBox(width: 50,),
                  MaterialButton(
                    child: Text("Custom"),
                    textColor: gameTypeIndex==1 ? Colors.black : Colors.grey,
                    onPressed: () {
                      setState(() {
                        gameTypeIndex = 1;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Center(
                child: gameTypeIndex == 0
                  ? StandardGameOptions(holeNum: holeNum, setHoleNumCallback: setHoleNumCallback) 
                  : CustomGameOptions(holeNum: holeNum, setHoleNumCallback: setHoleNumCallback),
              ),
              SizedBox(height: 60,),
              Expanded(
                child: ListView.builder(
                  itemCount: playerWidgets.length,
                  itemBuilder: (context, index) {
                    return playerWidgets.elementAt(index);
                  },
                ),
              ),
              SizedBox(height: 10,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    Future<String> gameIdFuture = Utils.postGame(globals.user.clubId, holeNum, players);
                    gameIdFuture.then((gameId) {

                      Future<Game> game_future = Utils.getGame(gameId);
                      game_future.then((newGame) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new GamePage(game: newGame),
                          )
                        );
                      });
                    });
                  },
                  child: Text("Start Game",
                    textAlign: TextAlign.center,
                  ),
                ),
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
  Function(int) setHoleNumCallback;

  StandardGameOptions({required this.holeNum, required this.setHoleNumCallback});

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
                widget.setHoleNumCallback(9);
              }
            ),
            SizedBox(width: 20,),
            MaterialButton(
              child: Text("18"),
              textColor: widget.holeNum==18 ? Colors.black : Colors.grey,
              onPressed: () {
                widget.setHoleNumCallback(18);
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
  Function(int) setHoleNumCallback;

  CustomGameOptions({required this.holeNum, required this.setHoleNumCallback});

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
    );

    final numMinsField = ArrowSelection(
      title: "", 
      items: [for(var i=15; i<180; i+=15) i], 
      itemIndex: 0, 
    );

    return Column(
      children: <Widget>[
        SizedBox(height: 10,),
        Text("Number of Holes"),
        SizedBox(height: 20,),
        numHolesField,
        SizedBox(height: 10,),
        Text("Number of Minutes"),
        SizedBox(height: 20,),
        numMinsField
      ],
    );
  }
}
