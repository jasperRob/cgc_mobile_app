/* 
User Class

Used to store data regarding a users profile

Authors: Jasper Robison
*/

import 'dart:convert';

Codec stringToBase64 = utf8.fuse(base64);

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String clubId;
  String gender;
  String birthDate;
  int handicap;
  int totalGames;
  int avgScore;
  String created;
  String updated;

  User({
    required this.id, 
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.clubId,
    required this.gender,
    required this.birthDate,
    required this.handicap,
    required this.totalGames,
    required this.avgScore,
    required this.created,
    required this.updated
    });

  factory User.fromJSON(dynamic data) {
    return User(
      // Graphene appends class name then Base64 encodes any ID.
      id: data["id"],
      firstName: data["first_name"],
      lastName: data["last_name"],
      email: data["email"],
      clubId: data["club_id"],
      gender: data["gender"],
      birthDate: data["birth_date"],
      handicap: data["handicap"],
      totalGames: data["total_games"],
      avgScore: data["avg_score"],
      created: data["created"],
      updated: data["updated"],
    );
  }

  String fullName() {
    return this.firstName + " " + this.lastName;
  }
}


