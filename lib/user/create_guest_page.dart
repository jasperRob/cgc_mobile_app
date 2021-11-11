/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


Future<dynamic> createGame(Club club, int numMinutes, List<User> players) async {


  List playerIds = new List<String>.from(players.map((item) {
    return item.id.hexString;
  }));

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.CREATE_GAME),
    variables: {
      "createGameClubId": club.id.hexString,
      "createGameNumMinutes": numMinutes,
      "createGamePlayerIds": playerIds,
      "createGameEnded": false
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);

  print(result.exception.toString());
  print(result.data);
  return result.data["createGame"];
}

class CreateGuestPage extends StatefulWidget {

  Function(User) callback;

  CreateGuestPage({required this.callback});

  @override
  CreateGuestState createState() => CreateGuestState();
}

class CreateGuestState extends State<CreateGuestPage> {

  late User user;

  @override
  Widget build(BuildContext context) {

    TextEditingController nameController = new TextEditingController();
    final nameField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextField(
        controller: nameController,
        obscureText: false,
        style: globals.style,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Add a guest",
          style: TextStyle(color: Colors.black),
        ),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop(Future.error("No User selected!"));
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: nameField,
              ),
              // Need Handicap/Difficulty and gender field too
              Flexible(
                flex: 1,
                child: Container(
                  child: Material(
                    elevation: 5.0,
                    borderRadius: globals.radius,
                    color: globals.primaryDarkColor,
                    child: MaterialButton(
                      // minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async {
                        widget.callback(user);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text("Add Guest",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: globals.primaryLightColor
                        )
                      ),
                    ),
                  )
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

