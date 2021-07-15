/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'classes/globals.dart' as globals;

class SettingsPage extends StatelessWidget{

  const SettingsPage();
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: globals.primaryDarkColor),
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
