import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../classes/export.dart';

class Utils {

  static String orNAInt(int value) {
    if (value == null) {
      return "N/A";
    }
    return value.toString();
  }

  static String orNA(String value) {

    if (value == null) {
      return "N/A";
    }
    return value;
  }

}
