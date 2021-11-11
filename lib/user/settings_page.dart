/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


class SettingsPage extends StatelessWidget{

  const SettingsPage();
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: globals.primaryDarkColor
          // primaryColor: Colors.green[300]
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text("Settings"),
          // titleSpacing: 0.0,

        ),
      )
    );
  }
}
