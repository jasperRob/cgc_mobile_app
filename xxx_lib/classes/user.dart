/* 
User Class

Used to store data regarding a users profile

Authors: Jasper Robison
*/

import 'dart:convert';

import 'club.dart';

Codec stringToBase64 = utf8.fuse(base64);

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  String clubId;
  Club club;
  String gender;
  String birthDate;
  int handicap;
  int totalGames;
  int avgScore;
  String created;
  String updated;


  User({
    this.id, 
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.clubId,
    this.club,
    this.gender,
    this.birthDate,
    this.handicap,
    this.totalGames,
    this.avgScore,
    this.created,
    this.updated
    });

  factory User.fromJSON(dynamic data) {
    return User(
      // Graphene appends class name then Base64 encodes any ID.
      id: stringToBase64.decode(data["id"]).toString().substring(5), 
      firstName: data["firstName"],
      lastName: data["lastName"],
      email: data["email"],
      password: data["password"],
      club: data["club"] != null ? Club.fromJSON(data["club"]) : null,
      gender: data["gender"],
      birthDate: data["birthDate"],
      handicap: data["handicap"],
      totalGames: data["totalGames"],
      avgScore: data["avgScore"],
      created: data["created"],
      updated: data["updated"],
    );
  }

  String fullName() {
    return this.firstName + " " + this.lastName;
  }
}


