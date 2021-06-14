import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'classes/globals.dart' as globals;
import 'login.dart';
import 'login.dart';
import 'sign_up.dart';
import 'common.dart';
import 'settings_page.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: Login(),
    );
  }
}
