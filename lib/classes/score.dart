/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';
import 'user.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Score {
  late String id;
  late User player;
  late int value;

  Score(String id, int value) {
    this.id = id;
    this.value = value;
  }

  factory Score.fromJSON(dynamic data) {
    Score score = Score(
      stringToBase64.decode(data["id"]).toString().split(':')[1],
      data["value"]
    );
    if (data["player"] != null) {
      score.player = User.fromJSON(data["player"]);
    }
    return score;
  }
}


