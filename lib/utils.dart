import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'classes/user.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 'classes/game.dart';

class Utils {

  String apiUrl = "https://localhost:8080";

  static Future<List<Game>> fetchGamesActive(String userId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/games/active?user_id=${userId}"));

    if (response.statusCode == 200) {
      List<Game> games = (json.decode(response.body) as List).map((i) =>
                    Game.fromJSON(i)).toList();
      return games;
    } else {
      throw Exception('Failed to get Games');
    }
  }

  static Future<List<Game>> fetchGamesInactive(String userId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/games/inactive?user_id=${userId}"));
    
    if (response.statusCode == 200) {
      List<Game> games = (json.decode(response.body) as List).map((i) =>
                    Game.fromJSON(i)).toList();
      return games;
    } else {
      throw Exception('Failed to get Games');
    }
  }

  static Future<List<User>> fetchFriends(String userId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/friends?user_id=${userId}"));
    List<User> users;

    users=(json.decode(response.body) as List).map((i) =>
                  User.fromJSON(i)).toList();
    return users;
  }

  static Future<List<User>> fetchRequested(String userId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/requests?user_id=${userId}"));
    List<User> users;

    users=(json.decode(response.body) as List).map((i) =>
                  User.fromJSON(i)).toList();
    return users;
  }

  static Future<List<User>> fetchRequests(String userId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/requests/target?user_id=${userId}"));
    List<User> users;

    users=(json.decode(response.body) as List).map((i) =>
                  User.fromJSON(i)).toList();
    return users;
  }
  
  static Future<Game> getGame(String gameId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/game?game_id=${gameId}"));
    print(json.decode(response.body));
    
    if (response.statusCode == 200) {
      return Game.fromJSON(json.decode(response.body));
    } else {
      throw Exception('Failed to get game');
    }
  }

  static Future<List<Hole>> getHoles(String gameId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/game/holes?game_id=${gameId}"));
    
    if (response.statusCode == 200) {
      List<Hole> holes = (json.decode(response.body) as List).map((i) =>
                    Hole.fromJSON(i)).toList();
      return holes;
    } else {
      throw Exception('Failed to get Holes');
    }
  }
  
  static Future<List<User>> getPlayers(String gameId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/game/players?game_id=${gameId}"));
    
    if (response.statusCode == 200) {
      List<User> users = (json.decode(response.body) as List).map((i) =>
                    User.fromJSON(i)).toList();
      return users;
    } else {
      throw Exception('Failed to get Players');
    }
  }

  static Future<List<Score>> getScores(String holeId) async {

    var response = await http.get(Uri.parse("http://localhost:8080/hole/scores?hole_id=${holeId}"));
    
    if (response.statusCode == 200) {
      List<Score> scores = (json.decode(response.body) as List).map((i) =>
                    Score.fromJSON(i)).toList();
      return scores;
    } else {
      throw Exception('Failed to get Score');
    }
  }

  static Future<List<Score>> getAllScores(String gameId) async {
    print("GETTING SCORES FOR " + gameId);

    var response = await http.get(Uri.parse("http://localhost:8080/game/holes/scores?game_id=${gameId}"));
    
    if (response.statusCode == 200) {
      List<Score> scores = (json.decode(response.body) as List).map((i) =>
                    Score.fromJSON(i)).toList();
      return scores;
    } else {
      throw Exception('Failed to get Score');
    }
  }

  static Future<List<User>> searchUsers(String keyword) async {

    var response = await http.get(Uri.parse("http://localhost:8080/user/search?keyword=${keyword}"));
    
    if (response.statusCode == 200) {
      List<User> users = (json.decode(response.body) as List).map((i) =>
                    User.fromJSON(i)).toList();
      return users;
    } else {
      throw Exception('Failed to get Players');
    }
  }

  static Future<String> postGame(String clubId, int numHoles, List<User> players) async {

    List<String> playerIds = [];

    for (User player in players) {
      playerIds.add(player.id);
    }

    var response = await http.post(
      Uri.parse('http://localhost:8080/game'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'club_id': clubId,
        'num_holes': numHoles,
        'player_ids': playerIds,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)["game_id"];
    } else {
      throw Exception('Failed to create game.');
    }
  }

  static Future<String> postScore(String holeId, String userId, int value) async {

    var response = await http.post(
      Uri.parse('http://localhost:8080/score'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'hole_id': holeId,
        'user_id': userId,
        'value': value,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)["score_id"];
    } else {
      throw Exception('Failed to create score.');
    }
  }

  static Future<bool> postFriendship(String sourceId, String targetId) async {

    var response = await http.post(
      Uri.parse('http://localhost:8080/user/friends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'source_id': sourceId,
        'target_id': targetId,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create frienship.');
    }
  }

  static Future<bool> acceptFriendship(String sourceId, String targetId) async {

    var response = await http.put(
      Uri.parse('http://localhost:8080/user/friends'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'source_id': sourceId,
        'target_id': targetId,
        'accepted': false,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to create frienship.');
    }
  }

  static Future<void> finishGame(Game game) async {

    var response = await http.put(
      Uri.parse("http://localhost:8080/game?game_id=${game.id}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'active': false,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create game.');
    }
  }
}
