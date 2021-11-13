import 'export.dart';

class Game extends CGCObject {
  late Club club;
  late int numHoles;
  late List<Hole> holes;
  late List<User> players;

  Game(String id, bool active, int numHoles, List<Hole> holes, List<User> players) : super(id, active) {
    this.numHoles = numHoles;
    this.holes = holes;
    this.players = players;
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

    // // Create Player List
    // List<User> winners = [];
    // if (data["winners"] != null) {
    //   winners = new List.from(data["winners"]["edges"].map((item) {
    //     return User.fromJSON(item["node"]);
    //   }));
    // }
    Game game = Game(
      // Graphene appends class name then Base64 encodes any ID.
      data['id'],
      data["active"],
      data["numHoles"],
      holes,
      players
    );
    if (data["club"] != null) {
      game.club = Club.fromJSON(data["club"]);
    }
    return game;
  }

}


