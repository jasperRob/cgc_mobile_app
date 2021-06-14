/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'package:cgc_mobile_app/classes/game.dart';

import 'score.dart';
import 'user.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Player {
  String id;
  Game game;
  User user;
  List<Score> scores;
  String created;
  String updated;


  Player({
    this.id,
    this.game, 
    this.user,
    this.scores,
    this.created,
    this.updated
    });

  factory Player.fromJSON(dynamic data) {
    List<Score> scores = null;
    if (data["scores"] != null && data["scores"]["edges"].length > 0) {
      scores = new List<Score>.from(data["scores"]["edges"].map((item) {
        return Score.fromJSON(item["node"]);
      }));
    }
    return Player(
      id: stringToBase64.decode(data["id"]).toString().substring(7), 
      game: data["game"] != null ? Game.fromJSON(data["game"]) : null,
      user: data["user"] != null ? User.fromJSON(data["user"]) : null,
      scores: scores,
      created: data["created"],
      updated: data["updated"],
    );
  }
}


