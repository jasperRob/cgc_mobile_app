
/* 
User Class

Used to store data regarding a users profile

Authors: Jasper Robison
*/

import 'dart:convert';

Codec stringToBase64 = utf8.fuse(base64);

class Club {
  late String id;
  late String name;
  late String email;
  late String phone;
  late String address;
  late String city;
  late String state;
  late String country;
  late String zipCode;

  Club(String id, String name, String email, String phone, String address, String city, String state, String country, String zipCode) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.phone = phone;
    this.address = address;
    this.city = city;
    this.state = state;
    this.country = country;
    this.zipCode = zipCode;
    }

  factory Club.fromJSON(dynamic data) {
    return Club(
      // Graphene appends class name then Base64 encodes any ID.
      stringToBase64.decode(data["id"]).toString().split(':')[1], 
      data["name"],
      data["email"],
      data["phone"],
      data["address"],
      data["city"],
      data["state"],
      data["country"],
      data["zipCode"]
    );
  }

  String graphqlID() {
    return stringToBase64.encode("Club:" + this.id).toString();
  }
}
