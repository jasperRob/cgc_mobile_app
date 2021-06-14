/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'club.dart';
import 'player.dart';
import 'user.dart';
import 'hole.dart';
import 'score.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Game {
  String id;
  Club club;
  int numHoles;
  List<Hole> holes;
  bool active;
  List<Player> players;
  String created;
  String updated;


  Game({
    this.id, 
    this.club,
    this.numHoles,
    this.holes,
    this.active,
    this.players,
    this.created,
    this.updated
    });

  factory Game.fromJSON(dynamic data) {
    // Create Hole list
    List<Hole> holes = null;
    if (data["holes"] != null) {
      holes = new List<Hole>.from(data["holes"]["edges"].map((item) {
        return Hole.fromJSON(item["node"]);
      }));
    }
    // Create Player List
    List<Player> players = null;
    if (data["players"] != null) {
      players = new List.from(data["players"]["edges"].map((item) {
        return Player.fromJSON(item["node"]);
      }));
    }
    return Game(
      // Graphene appends class name then Base64 encodes any ID.
      id: stringToBase64.decode(data["id"]).toString().substring(5),
      club: data["club"] != null ? Club.fromJSON(data["club"]) : null,
      numHoles: data["numHoles"],
      holes: holes,
      active: data["active"],
      players: players,
      created: data["created"],
      updated: data["updated"],
    );
  }
}


