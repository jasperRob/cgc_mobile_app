/* 
Game Class

Used to store data regarding games

Authors: Jasper Robison
*/

import 'dart:convert';
import 'score.dart';
import 'package:objectid/objectid.dart';

Codec stringToBase64 = utf8.fuse(base64);

class CGCObject {
  late ObjectId id;
  late String className;
  late bool active;
  late DateTime created;

  CGCObject(String id, bool active) {
    var idArray = stringToBase64.decode(id).toString().split(':');
    if (id.length > 1) {
      this.id = ObjectId.fromHexString(idArray[1]);
      this.className = idArray[0];
    } else {
      this.id = ObjectId.fromHexString(id);
    }
    this.active = active;
    this.created = this.id.timestamp;
  }

  static DateTime idToCreated(String id) {
    String sub = id.substring(0, 8);
    int p = int.parse(sub, radix: 16);
    DateTime dateTime = new DateTime.fromMicrosecondsSinceEpoch(p);
    return dateTime;
  }

  String graphqlID() {
    return stringToBase64.encode(this.className + ":" + this.id.hexString).toString();
  }

}


