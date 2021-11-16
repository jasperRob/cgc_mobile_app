import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vector;

import '../classes/export.dart';

class Utils {

  static String orNA(String value) {

    if (value == null) {
      return "N/A";
    }
    return value;
  }

  static String orNAInt(int value) {
    if (value == null) {
      return "N/A";
    }
    return value.toString();
  }

  static String orNADouble(double value) {
    if (value == null) {
      return "N/A";
    }
    return value.toString();
  }

  static double adjustedDistance(int distance, int holeNum, double windStrength, int handicap) {

    double difficultyFactor = 1.0;
    if (handicap > 27) {
      difficultyFactor = 0.5;
    } else if (handicap >= 19 && handicap <= 27) {
      difficultyFactor = 0.75;
    } else if (handicap >= 10 && handicap <= 18) {
      difficultyFactor = 1.0;
    } else if (handicap >= 1 && handicap <= 9) {
      difficultyFactor = 1.25;
    }

    double factor = 0.0;
    if ((holeNum+1) % 3 == 0) {
      factor =  math.sin(vector.radians(60)) * windStrength;
    } else if ((holeNum+1) % 3 == 1) {
      factor =  -1 * math.sin(vector.radians(60)) * windStrength;
    }
    return (distance + (distance * factor)) * difficultyFactor;
  }

}
