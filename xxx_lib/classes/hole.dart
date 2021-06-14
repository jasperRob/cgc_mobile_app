/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'package:cgc_mobile_app/classes/score.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Hole {
  String id;
  String gameId;
  int holeNum;
  int par;
  List<Score> scores;
  String created;
  String updated;


  Hole({
    this.id, 
    this.gameId,
    this.holeNum,
    this.par,
    this.scores,
    this.created,
    this.updated
    });

  factory Hole.fromJSON(dynamic data) {
    // Create Score list
    List<Score> scores = null;
    if (data["scores"] != null && data["scores"]["edges"].length > 0) {
      scores = new List<Score>.from(data["scores"]["edges"].map((item) {
        return Score.fromJSON(item["node"]);
      }));
    }
    return Hole(
      // Graphene appends class name then Base64 encodes any ID.
      id: data["id"] != null ? stringToBase64.decode(data["id"]).toString().substring(5) : null,
      gameId: data["gameId"],
      holeNum: data["holeNum"],
      par: data["par"],
      scores: scores,
      created: data["created"],
      updated: data["updated"],
    );
  }
}


