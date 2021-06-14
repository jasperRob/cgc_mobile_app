/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'classes/globals.dart' as globals;
import 'classes/game.dart';
import 'game_page.dart';
import 'finished_game_page.dart';
import 'utils.dart';

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
    String dateString = getSimpleDate(dateFormat.parse(game.created));
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
              child: FutureBuilder<List<Game>>(
                future: Utils.fetchGamesActive(globals.user.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.isNotEmpty
                      ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return
                            Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: getGameTitle(snapshot.data[index]),
                                    trailing: MaterialButton(
                                      child: Text("View"),
                                      onPressed: () {
                                        Game game = snapshot.data[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => new GamePage(
                                              game: game,
                                              ),
                                          )
                                        );
                                      }
                                    )
                                  )
                                ],
                              ),
                            );
                        })
                      : Center(child: Text("No Active Games"));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text("Previous Games")
            ),
            Container(
              child: FutureBuilder<List<Game>>(
                future: Utils.fetchGamesInactive(globals.user.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData){
                    // print(snapshot.data[0]);
                    return snapshot.data.isNotEmpty
                      ? ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return
                            Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: getGameTitle(snapshot.data[index]),
                                    trailing: MaterialButton(
                                      child: Text("View"),
                                      onPressed: () {
                                        Game game = snapshot.data[index];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => new FinishedGamePage(
                                              game: game,
                                              ),
                                          )
                                        );
                                      }
                                    )
                                  )
                                ],
                              ),
                            );
                        })
                      : Center(child: Text("No Inactive Games"));
                  }else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
