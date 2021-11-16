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


Future<dynamic> createGuestUser(Club club, User user) async {

  print("EMAIL = " + user.email);

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.CREATE_GUEST_USER),
    variables: {
      "clubId": club.id.hexString,
      "email": user.email,
      "firstName": user.firstName,
      "lastName": user.lastName,
      "gender": user.gender,
      "handicap": user.handicap,
      "totalGames": 0,
      "guest": true,
      "admin": false,
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);

  print(result.exception.toString());
  print(result.data);
  return result.data["createUser"];
}

class CreateGuestPage extends StatefulWidget {

  late Function(User) callback;
  late User user;

  CreateGuestPage(Function(User) callback, User user) {
     this.callback = callback;
     this.user = user;
     this.user.handicap = 27;
   }

  @override
  CreateGuestState createState() => CreateGuestState();
}

class CreateGuestState extends State<CreateGuestPage> {

  static TextEditingController emailController = new TextEditingController();
  static TextEditingController firstNameController = new TextEditingController();
  static TextEditingController lastNameController = new TextEditingController();

  int itemIndex = 26;

  void setHandicapCallback(int value) {
    // setState(() {
      widget.user.handicap = value;
    // });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      print("updating email");
      widget.user.email = emailController.text;
      print("widget user email = " + widget.user.email);
    });
    firstNameController.addListener(() {
      widget.user.firstName = firstNameController.text;
      print("widget user firstName = " + widget.user.firstName);
    });
    lastNameController.addListener(() {
      widget.user.lastName = lastNameController.text;
      print("widget user last name = " + widget.user.lastName);
    });
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the widget is removed from the
  //   // widget tree.
  //   emailController.dispose();
  //   firstNameController.dispose();
  //   lastNameController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {

    final emailField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextFormField(
        controller: emailController,
        textCapitalization: TextCapitalization.none,
        obscureText: false,
        style: globals.guestStyle,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );

    final firstNameField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextFormField(
        controller: firstNameController,
        obscureText: false,
        style: globals.guestStyle,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );


    final lastNameField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextFormField(
        controller: lastNameController,
        obscureText: false,
        style: globals.guestStyle,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Name",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );

    final genderField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        MaterialButton(
          child: Text("Male"),
          onPressed: () {
            widget.user.gender = "M";
          },
        ),
        MaterialButton(
          child: Text("Female"),
          onPressed: () {
            widget.user.gender = "F";
          },
        ),
      ]
    );

    final difficultyField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text("Beginner",
                  style: TextStyle(fontSize: 10),
              ),
              onPressed: () {
                widget.user.handicap = 36;
                setState(() {
                  itemIndex = 35;
                });
              },
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text("Intermediate",
                  style: TextStyle(fontSize: 10),
              ),
              onPressed: () {
                widget.user.handicap = 27;
                setState(() {
                  itemIndex = 26;
                });
              },
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text("Advanced",
                  style: TextStyle(fontSize: 10),
              ),
              onPressed: () {
                widget.user.handicap = 18;
                setState(() {
                  itemIndex = 17;
                });
              },
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text("Pro",
                  style: TextStyle(fontSize: 10),
              ),
              onPressed: () {
                widget.user.handicap = 9;
                setState(() {
                  itemIndex = 8;
                });
              },
          ),
        ),
      ]
    );

    // final handicapField = ArrowSelection(
    //   title: "", 
    //   items: [for(var i=1; i<=54; i++) i], 
    //   itemIndex: widget.user.handicap-1, 
    //   callback: setHandicapCallback
    // );
    final items = [for(var i=1; i<=54; i++) i];

    final handicapField = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Flexible(
        //   flex: 1,
        //   child: Text(title),
        // ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              minWidth: 5,
              child: Icon(Icons.arrow_left),
              onPressed: () {
                if (itemIndex > 0) {
                  setState(() {
                    itemIndex -= 1;
                  });
                  widget.user.handicap = items.elementAt(itemIndex);
                  // widget.callback(items.elementAt(itemIndex));
                }
              },
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text(items.elementAt(itemIndex).toString()),
              onPressed: () {
                print("dummy button pressed");
              }
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              minWidth: 5,
              child: Icon(Icons.arrow_right),
              onPressed: () {
                if (itemIndex < (items.length-1)) {
                  setState(() {
                    itemIndex += 1;
                  });
                  widget.user.handicap = items.elementAt(itemIndex);
                  // widget.callback(items.elementAt(itemIndex));
                }
              },
          ),
        ),
      ],
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
              Spacer(),
              // Text("Select Email"),
              Flexible(
                flex: 1,
                child: emailField,
              ),
              Spacer(),
              // Text("Select First Name"),
              Flexible(
                flex: 1,
                child: firstNameField,
              ),
              Spacer(),
              // Text("Select Last Name"),
              Flexible(
                flex: 1,
                child: lastNameField,
              ),
              Spacer(),
              Text("Select Gender",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: genderField,
              ),
              Spacer(),
              Text("Select Difficulty",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: difficultyField,
              ),
              Spacer(),
              Text("Select Handicap",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Flexible(
                flex: 1,
                child: handicapField,
              ),
              Spacer(),
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

                        print("user firstName = " + widget.user.firstName);

                        dynamic data = await createGuestUser(globals.user.club, widget.user);

                        print("getting new user");
                        print(data);

                        User newUser = User.fromJSON(data["user"]);

                        widget.callback(newUser);
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
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

