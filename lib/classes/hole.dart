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
  late int distance;
  late Map<String, String> start;
  late Map<String, String> finish;
  late List<Score> scores;

  Hole(String id, int holeNum, int par, int distance, Map<String, String> start, Map<String, String> finish, List<Score> scores) {
    this.id = id;
    this.holeNum = holeNum;
    this.par = par;
    this.distance = distance;
    this.start = start;
    this.finish = finish;
    this.scores = scores;
  }

  factory Hole.fromJSON(dynamic data) {

    List<Score> scores = [];
    if (data["scores"] != null) {
      scores = new List<Score>.from(data["scores"]["edges"].map((item) {
        return Score.fromJSON(item["node"]);
      }));
    }

    Map<String, String> start = new Map<String, String>();
    if (data["start"] != null) {
      dynamic decoded = json.decode(data["start"]);
      start["longitude"] = decoded["longitude"].toString();
      start["latitude"] = decoded["latitude"].toString();
    }
    Map<String, String> finish = new Map<String, String>();
    if (data["finish"] != null) {
      dynamic decoded = json.decode(data["finish"]);
      finish["longitude"] = decoded["longitude"].toString();
      finish["latitude"] = decoded["latitude"].toString();
    }
    
    return Hole(
      stringToBase64.decode(data["id"]).toString().split(':')[1],
      data["holeNum"],
      data["par"],
      data["distance"],
      start,
      finish,
      scores
    );
  }
}


