import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'classes/user.dart';
import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
import 'utils.dart';

import 'location_utils.dart';

Future<dynamic> submitScore(Hole hole, User player, int value) async {

  const CREATE_SCORE = """
  mutation Mutations(\$createScoreHoleId: String!, \$createScorePlayerId: String!, \$createScoreValue: Int!) {
    createScore(holeId: \$createScoreHoleId, playerId: \$createScorePlayerId, value: \$createScoreValue) {
      ok
      score {
        id
        player {
          id
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
      "createScoreHoleId": hole.id,
      "createScorePlayerId": player.id,
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
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              SizedBox(height: 60,),
              Row(
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
              SizedBox(height: 20,),
              Center(
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
              SizedBox(height: 40,),
              ConstrainedBox(
                constraints: new BoxConstraints(
                  maxHeight: 350,
                ),
                child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        -37.734039,
                        145.230148
                      ),
                      zoom: 18,
                    ),
                    mapType: MapType.hybrid,
                    myLocationEnabled: true
                ),
              ),
              SizedBox(height: 40,),
              ArrowSelection(
                title: "Your Score: ", 
                items: [for(var i=1; i<50; i+=1) i], 
                itemIndex: widget.hole.par-1, 
                callback: setScoreCallback
              ),
              SizedBox(height: 40,),
              Material(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
