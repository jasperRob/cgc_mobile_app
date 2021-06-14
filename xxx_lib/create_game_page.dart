/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:cgc_mobile_app/classes/graphql_utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/player.dart';
import 're-usable/arrow_selection.dart';
import 're-usable/player_selector.dart';
import 'common.dart';
import 'classes/game.dart';
import 'classes/user.dart';
import 'package:flutter/material.dart';
import 'game_preview_page.dart';

import 'classes/globals.dart' as globals;


class CreateGamePage extends StatefulWidget {

  int numHoles = 9;
  int numMinutes = null;

  @override
  CreateGameState createState() => CreateGameState();
}

class CreateGameState extends State<CreateGamePage> {

  int gameTypeIndex = 0;

  // Null item for every player we want to be able to add
  List<User> players = [globals.user, null, null, null];


  void setPlayerCallback(User user, int index) {
    List<User> playerList = players;
    playerList[index] = user;
    for (int i = 0; i < playerList.length; i++) {
      if (i < (playerList.length-1) && playerList.elementAt(i) == null && playerList.elementAt(i+1) != null) {
        playerList.removeAt(i);
        playerList.add(null);
      }
    }
    setState(() {
      players = playerList;
    });
    // Only shift if a user has been removed
  }

  void setNumHolesCallback(int n) {
    setState(() {
      widget.numHoles = n;
    });
  }

  void setNumMinutesCallback(int n) {
    setState(() {
      widget.numMinutes = n;
    });
  }
  

  @override
  Widget build(BuildContext context) {

    // initPlayers();

    // Create a list of already selected players for selectors to access
    final alreadySelected = <User>[];
    for (var item in players) {
      if (item != null) {
        alreadySelected.add(item);
      }
    }
    // Create our player selectors
    final playerSelectors = <Widget>[];
    for (int i = 0; i < players.length; i++) {
      User item = players[i];
      if (item == globals.user) {
        playerSelectors.add(
          PlayerSelector(
            title: "Player " + (i+1).toString(), 
            initPlayer: players.elementAt(i), 
            disabled: true
          )
        );
      } else {
        playerSelectors.add(
          PlayerSelector(
            title: "Player " + (i+1).toString(), 
            initPlayer: players.elementAt(i), 
            playerIndex: i, 
            callback: setPlayerCallback, 
            alreadySelected: alreadySelected,
            disabled: false,
          )
        );
      }
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
              Center(
                child: gameTypeIndex == 0 ? StandardGameOptions(numHolesCallback: setNumHolesCallback,) : CustomGameOptions(numHolesCallback: setNumHolesCallback,),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    return playerSelectors.elementAt(index);
                  },
                ),
              ),
              SizedBox(height: 20,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    // Remove Nulls
                    players.removeWhere((element) => element == null);
                    Game game = new Game(
                      club: globals.user.club,
                      numHoles: widget.numHoles,
                      players: players.map((item) => new Player(user: item)).toList(),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new GamePreviewPage(game: game),
                      )
                    );
                  },
                  child: Text("Next",
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

  Function(int) numHolesCallback;
  Function(int) numMinutesCallback;

  StandardGameOptions({this.numHolesCallback, this.numMinutesCallback});

  @override
  StandardGameOptionsState createState() => StandardGameOptionsState();
}

class StandardGameOptionsState extends State<StandardGameOptions> {

  int holeNum = 9;

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
              textColor: holeNum==9 ? Colors.black : Colors.grey,
              onPressed: () {
                setState(() {
                  holeNum = 9;
                });
                widget.numHolesCallback(9);
              },
            ),
            SizedBox(width: 20,),
            MaterialButton(
              child: Text("18"),
              textColor: holeNum==18 ? Colors.black : Colors.grey,
              onPressed: () {
                setState(() {
                  holeNum = 18;
                });
                widget.numHolesCallback(18);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class CustomGameOptions extends StatefulWidget {

  Function(int) numHolesCallback;
  Function(int) numMinutesCallback;

  CustomGameOptions({this.numHolesCallback, this.numMinutesCallback});

  @override
  CustomGameOptionsState createState() => CustomGameOptionsState();
}

class CustomGameOptionsState extends State<CustomGameOptions> {

  @override
  Widget build(BuildContext context) {

    final numHolesField = ArrowSelection(
      title: "", 
      items: [for(var i=1; i<19; i+=1) i], 
      itemIndex: 9, 
      callback: widget.numHolesCallback
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
        ArrowSelection(
          title: "", 
          items: [for(var i=5; i<361; i+=5) i], 
          itemIndex: 11, 
          callback: widget.numMinutesCallback
        )
      ],
    );
  }
}
