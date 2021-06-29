/*
Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'club.dart';
import 'user.dart';
import 'hole.dart';
import 'score.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Game {
  late String id;
  late Club club;
  late int numHoles;
  late List<Hole> holes;
  late List<User> players;
  late bool active;

  Game(String id, int numHoles, List<Hole> holes, List<User> players, bool active) {
    this.id = id;
    this.numHoles = numHoles;
    this.holes = holes;
    this.players = players;
    this.active = active;
  }

  factory Game.fromJSON(dynamic data) {
    // Create Hole list
    List<Hole> holes = [];
    if (data["holes"] != null) {
      holes = new List<Hole>.from(data["holes"]["edges"].map((item) {
        return Hole.fromJSON(item["node"]);
      }));
    }
    // Create Player List
    List<User> players = [];
    if (data["players"] != null) {
      players = new List.from(data["players"]["edges"].map((item) {
        return User.fromJSON(item["node"]);
      }));
    }

    // Create Player List
    List<User> winners = [];
    if (data["winners"] != null) {
      winners = new List.from(data["winners"]["edges"].map((item) {
        return User.fromJSON(item["node"]);
      }));
    }
    Game game = Game(
      // Graphene appends class name then Base64 encodes any ID.
      stringToBase64.decode(data["id"]).toString().split(':')[1], 
      data["numHoles"],
      holes,
      players,
      data["active"]
    );
    if (data["club"] != null) {
      game.club = Club.fromJSON(data["club"]);
    }
    return game;
  }

  String graphqlID() {
    return stringToBase64.encode("Game:" + this.id).toString();
  }

  String getCreated() {
    return this.id;
  }
}


