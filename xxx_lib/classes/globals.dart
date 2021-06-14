library cgc_mobile_app.globals;

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'club.dart';
import 'user.dart';

FlutterSecureStorage storage = new FlutterSecureStorage();

String uri = 'http://localhost:8080/data';

User user;

