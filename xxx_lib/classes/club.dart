/* 
User Class

Used to store data regarding a users profile

Authors: Jasper Robison
*/

import 'dart:convert';

Codec stringToBase64 = utf8.fuse(base64);

class Club {
  String id;
  String name;
  String email;
  String phone;
  String address;
  String state;
  String country;
  String zipCode;
  String created;
  String updated;


  Club({
    this.id, 
    this.name,
    this.email,
    this.phone,
    this.address,
    this.state,
    this.country,
    this.zipCode,
    this.created,
    this.updated
    });

  factory Club.fromJSON(dynamic data) {
    return Club(
      // Graphene appends class name then Base64 encodes any ID.
      id: stringToBase64.decode(data["id"]).toString().substring(5), 
      name: data["name"],
      email: data["email"],
      phone: data["phone"],
      address: data["address"],
      state: data["state"],
      country: data["country"],
      zipCode: data["zipCode"],
      created: data["created"],
      updated: data["updated"],
    );
  }
}


