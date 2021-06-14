import 'package:cgc_mobile_app/home_page.dart';
import 'package:cgc_mobile_app/friends_page.dart';
import 'package:cgc_mobile_app/create_game_page.dart';
import 'package:cgc_mobile_app/settings_page.dart';
import 'package:flutter/material.dart';
import 'main.dart';


class Common extends StatefulWidget {

  @override
  CommonBodyState createState() => CommonBodyState();
}

class CommonBodyState extends State<Common> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CreateGamePage(),
    FriendsPage(),
  ];

   static const List<String> _textOptions = <String>[
    "Home",
    "Create Game",
    "Friends",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.green[300]),
      home: Scaffold(
        appBar: AppBar(
          // leading: Icon(
          //   Icons.arrow_back
          // ),
          title: Text(_textOptions.elementAt(_selectedIndex)),
          // titleSpacing: 0.0,
          actions: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0),
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    )
                  );
                },
              ),
            ),
          ]
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text("Home")
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.add),
              title: new Text("Create Game")
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.people),
              title: new Text("Friends")
            )
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
