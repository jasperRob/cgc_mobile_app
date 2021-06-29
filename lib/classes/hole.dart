/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';
import 'score.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Hole {
  late String id;
  late int holeNum;
  late int par;
  late List<Score> scores;

  Hole(String id, int holeNum, int par, List<Score> scores) {
    this.id = id;
    this.holeNum = holeNum;
    this.par = par;
    this.scores = scores;
  }

  factory Hole.fromJSON(dynamic data) {

    List<Score> scores = [];
    if (data["scores"] != null) {
      scores = new List<Score>.from(data["scores"]["edges"].map((item) {
        return Score.fromJSON(item["node"]);
      }));
    }

    return Hole(
      stringToBase64.decode(data["id"]).toString().split(':')[1],
      data["holeNum"],
      data["par"],
      scores
    );
  }
}


