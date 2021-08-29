import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:location/location.dart';
import 'main.dart';

import 'classes/export.dart';
import 'components/export.dart';
import 'utils/export.dart';
import 'user/export.dart';
import 'game/export.dart';

import 'globals.dart' as globals;

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

  @override
  void initState() {
    super.initState();
    // LocationUtils.checkLocationPermissions();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: ValueNotifier<GraphQLClient>(
            globals.client
        ),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.grey,
            primaryColor: globals.primaryDarkColor
            // primaryColor: Colors.green[300]
          ),
          home: Scaffold(
            appBar: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.badge),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClubPage(club: globals.user.club),
                        )
                      );
                    },
                  );
                },
              ),            
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
      ),
    );
  }
}
