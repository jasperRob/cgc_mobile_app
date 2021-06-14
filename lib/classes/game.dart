/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

class Game {
  String id;
  String clubId;
  int numHoles;
  bool active;
  String created;
  String updated;

  Game({
    required this.id, 
    required this.clubId, 
    required this.numHoles,
    required this.active,
    required this.created,
    required this.updated
    });

  factory Game.fromJSON(dynamic data) {
    return Game(
      id: data["id"],
      clubId: data["club_id"],
      numHoles: data["num_holes"],
      active: data["active"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


