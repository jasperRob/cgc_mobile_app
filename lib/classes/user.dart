/* 
User Class

Used to store data regarding a users profile

Authors: Jasper Robison
*/

import 'dart:convert';
import 'club.dart';
import 'req.dart';

Codec stringToBase64 = utf8.fuse(base64);

class User {
  late String id;
  late Club club;
  late List<User> friends;
  late List<Req> requests;
  late String firstName;
  late String lastName;
  late String email;
  late String gender;
  late String birthDate;
  late int handicap;
  late int totalGames;
  late int avgScore;

  User(String id, String firstName, String lastName, String email, String gender, String birthDate, int handicap, int totalGames, int avgScore, List<User> friends, List<Req> requests) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.gender = gender;
    this.birthDate = birthDate;
    this.handicap = handicap;
    this.totalGames = totalGames;
    this.avgScore = avgScore;
    this.friends = friends;
    this.requests = requests;
  }

  factory User.fromJSON(dynamic data) {

    List<User> friends = [];
    if (data["friends"] != null) {
      friends = new List<User>.from(data["friends"]["edges"].map((item) {
        return User.fromJSON(item["node"]);
      }));
    }

    List<Req> requests = [];
    if (data["requests"] != null) {
      requests = new List<Req>.from(data["requests"]["edges"].map((item) {
        return Req.fromJSON(item["node"]);
      }));
    }

    User user = User(
      // Graphene appends class name then Base64 encodes any ID.
      stringToBase64.decode(data["id"]).toString().split(':')[1],
      data["firstName"],
      data["lastName"],
      data["email"],
      data["gender"],
      data["birthDate"],
      data["handicap"],
      data["totalGames"],
      data["avgScore"],
      friends,
      requests
    );

    if (data["club"] != null) {
      user.club = Club.fromJSON(data["club"]);
    }
    return user;
  }

  String graphqlID() {
    return stringToBase64.encode("User:" + this.id).toString();
  }

  String fullName() {
    return this.firstName + " " + this.lastName;
  }
}


