/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';
import 'user.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Req {
  late String id;
  late User source;
  late User target;

  Req(String id) {
    this.id = id;
  }

  factory Req.fromJSON(dynamic data) {
    Req score = Req(
      stringToBase64.decode(data["id"]).toString().split(':')[1]
    );
    if (data["source"] != null) {
      score.source = User.fromJSON(data["source"]);
    }
    if (data["target"] != null) {
      score.target = User.fromJSON(data["target"]);
    }
    return score;
  }
}


