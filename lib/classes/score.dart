/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

class Score {
  String id;
  String gameId;
  String holeId;
  String userId;
  int value;
  String created;
  String updated;

  Score({
    required this.id,
    required this.gameId,
    required this.holeId,
    required this.userId,
    required this.value,
    required this.created,
    required this.updated
    });

  factory Score.fromJSON(dynamic data) {
    return Score(
      id: data["id"],
      gameId: data["game_id"],
      holeId: data["hole_id"],
      userId: data["user_id"],
      value: data["value"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


