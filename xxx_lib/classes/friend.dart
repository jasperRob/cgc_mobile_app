/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';

import 'user.dart';

Codec stringToBase64 = utf8.fuse(base64);

class Friend extends User{
  User user;
  bool accepted;
  String created;
  String updated;


  Friend({
    this.user,
    this.accepted,
    this.created,
    this.updated
    });

  factory Friend.fromJSON(dynamic data) {
    return Friend(
      user: data["user"] != null ? User.fromJSON(data["user"]) : null,
      accepted: data["accepted"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


