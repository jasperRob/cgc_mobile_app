/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'player.dart';
import 'hole.dart';
import 'game.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Score {
  String id;
  Game game;
  String holeId;
  Player player;
  int score;
  String created;
  String updated;


  Score({
    this.id,
    this.game,
    this.holeId,
    this.player,
    this.score,
    this.created,
    this.updated
    });

  factory Score.fromJSON(dynamic data) {
    return Score(
      id: stringToBase64.decode(data["id"]).toString().substring(6),
      game: data["game"] != null ? Game.fromJSON(data["game"]) : null,
      holeId: data["holeId"],
      player: data["player"] != null ? Player.fromJSON(data["player"]) : null,
      score: data["score"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


