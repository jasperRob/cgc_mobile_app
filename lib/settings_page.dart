/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget{

  const SettingsPage();
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[300]),
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
