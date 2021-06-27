/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

class Hole {
  String id;
  String gameId;
  int holeNum;
  int par;
  bool scoresExist;
  String created;
  String updated;

  Hole({
    required this.id,
    required this.gameId,
    required this.holeNum,
    required this.par,
    required this.scoresExist,
    required this.created,
    required this.updated
    });

  factory Hole.fromJSON(dynamic data) {
    return Hole(
      id: data["id"],
      gameId: data["game_id"],
      holeNum: data["hole_num"],
      par: data["par"],
      scoresExist: data["scores_exist"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


