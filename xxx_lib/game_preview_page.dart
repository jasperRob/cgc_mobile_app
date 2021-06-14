import 'classes/game.dart';
import 'hole_view.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'classes/globals.dart' as globals;
import 'classes/graphql_utils.dart';
import 'classes/hole.dart';
import 'game_page.dart';

class GamePreviewPage extends StatelessWidget {

  Game game;
  String token;

  GamePreviewPage({this.game});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Text("Your Game Options"),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Club"),
                  SizedBox(width: 40),
                  Text(game.club.name),
                ]
              ),
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Number of Holes"),
                  SizedBox(width: 40),
                  Text(game.numHoles.toString()),
                ]
              ),
              SizedBox(height: 30,),
              // Visibility(
              //   maintainSize: true, 
              //   maintainAnimation: true,
              //   maintainState: true,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text("Player One"),
              //       SizedBox(width: 40),
              //       Text(game.playerOne == null ? "" : game.playerOne.fullName()),
              //     ],
              //   ),
              //   visible: game.playerOne != null,
              // ),
              SizedBox(height: 30,),
              // Visibility(
              //   maintainSize: true, 
              //   maintainAnimation: true,
              //   maintainState: true,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text("Player Two"),
              //       SizedBox(width: 40),
              //       Text(game.playerTwo == null ? "" : game.playerTwo.fullName()),
              //     ],
              //   ),
              //   visible: game.playerTwo != null,
              // ),
              SizedBox(height: 30,),
              // Visibility(
              //   maintainSize: true, 
              //   maintainAnimation: true,
              //   maintainState: true,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text("Player Three"),
              //       SizedBox(width: 40),
              //       Text(game.playerThree == null ? "" : game.playerThree.fullName()),
              //     ],
              //   ),
              //   visible: game.playerThree != null,
              // ),
              SizedBox(height: 30,),
              // Visibility(
              //   maintainSize: true, 
              //   maintainAnimation: true,
              //   maintainState: true,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Text("Player Four"),
              //       SizedBox(width: 40),
              //       Text(game.playerFour == null ? "" : game.playerFour.fullName()),
              //     ],
              //   ),
              //   visible: game.playerFour != null,
              // ),
              SizedBox(height: 60,),
              Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                color: Colors.green[300],
                child: MaterialButton(
                  // minWidth: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () async {
                    await GraphQLUtils.createGameWithGame(game)
                    .catchError((error) {
                      throw(error);
                    })
                    .then((value) async {
                      // print(value.data);
                      Game game = Game.fromJSON(value.data["createGame"]["game"]);
                      
                      print("GAME ID: " + game.id);
                      print(game.holes);
                    
                      // Pop This page
                      Navigator.of(context).pop();
                      // Push Actual Game Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamePage(game: game),
                        )
                      );

                    });
                    // Cast to game to handle id decoding
                    // final List<User> users = <User>[];
                    // for (var item in result.data["usersByFriendUserId"]) {
                    //   users.add(User.fromJSON(item));
                    // }
                    // print("GAMEDATA");
                    // print(holeData["holesByGameId"]);
                    // List<Hole> holeList = List<Hole>.from(holeData["holesByGameId"]).map((item) => Hole.fromJSON(item)).toList();
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