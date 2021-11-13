import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


LatLng start = LatLng(
    -37.959155,
    145.085139
);

LatLng end = LatLng(
    -37.956397,
    145.086070
);

Future<dynamic> submitScore(Hole hole, User player, int value) async {

  const CREATE_SCORE = """
  mutation Mutations(\$createScoreHoleId: String!, \$createScorePlayerId: String!, \$createScoreValue: Int!) {
    createScore(holeId: \$createScoreHoleId, playerId: \$createScorePlayerId, value: \$createScoreValue) {
      ok
      score {
        id
        player {
          id
          firstName
          lastName
          email
          birthDate
          gender
          handicap
          totalGames
          admin
          active
        }
        value
      }
    }
  }
  """;

  print("VALUE: " + value.toString());
  MutationOptions mutationOptions = MutationOptions(
    document: gql(CREATE_SCORE),
    variables: {
      "createScoreHoleId": hole.id.hexString,
      "createScorePlayerId": player.id.hexString,
      "createScoreValue": value
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);
  return result.data["createScore"];
}

class HolePage extends StatefulWidget {

  Hole hole;
  Game game;
  Function(Hole, Score) nextHoleCallback;
  Function(Game) finishGameCallback;

  HolePage({required this.hole, required this.game, required this.nextHoleCallback, required this.finishGameCallback});

  @override
  HolePageState createState() => HolePageState(this.hole.par);

}

class HolePageState extends State<HolePage> {

  int score;
  // LocationData locationData = globals.locationData;

  HolePageState(this.score);

  @override
  void initState() {
    super.initState();
    // LocationUtils.checkLocationPermissions();
    // print("LAT:");
    // print(globals.locationData.latitude);
  }

  @override
  Widget build(BuildContext context) {

  void setScoreCallback(int value) {
    setState(() {
      this.score = value;
    });
  }

    // TODO: FIX THIS, MAKE SURE PREVIOUSLY SELECTED SCORE IS SHOWN

    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Hole #" + widget.hole.holeNum.toString()),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0),
            child: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ARTee(game: widget.game, hole: widget.hole),
                  )
                );
              },
            ),
          ),
        ]
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10,),

              Flexible(
                flex: 1,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Par  " + widget.hole.par.toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                        ),
                      ],
                  ),
              ),
              // SizedBox(height: 10,),
              Flexible(
                flex: 1,
                child: Center(
                  child: Row(children: [
                    Text("Distance: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        )),
                    SizedBox(width: 10),
                    Text(Utils.orNAInt(widget.hole.distance) + "m"),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center
                  )
                ),
              ),
              Flexible(
                flex: 5,
                child: Map(
                    location: start,
                    polylineCoordinates: <LatLng>[
                      start, 
                      end
                    ],
                ),
              ),
              Flexible(
                flex: 2,
                child: ArrowSelection(
                    title: "Your Score: ", 
                    items: [for(var i=1; i<50; i+=1) i], 
                    itemIndex: widget.hole.par-1, 
                    callback: setScoreCallback
                ),
              ),
              Flexible(
                flex: 1,
                child: Material(
                  elevation: 5.0,
                  borderRadius: globals.radius,
                  color: globals.primaryDarkColor,
                  child: MaterialButton(
                      // minWidth: MediaQuery.of(context).size.width,
                      child: Text((widget.game.numHoles == widget.hole.holeNum) ? "Finish" : "Submit Score",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: globals.primaryLightColor,
                          )
                      ),
                      padding: globals.padding,
                      onPressed: () async {
                        dynamic data = await submitScore(widget.hole, globals.user, score);
                        Score newScore = Score.fromJSON(data["score"]);
                        if (widget.game.numHoles == widget.hole.holeNum) {
                          widget.finishGameCallback(widget.game);
                        } else {
                          widget.nextHoleCallback(widget.hole, newScore);
                        }
                      }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
