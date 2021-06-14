import 'package:cgc_mobile_app/re-usable/gender_selection.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'main.dart';
import 're-usable/arrow_selection.dart';
import 're-usable/gender_selection.dart';
import 'classes/graphql_utils.dart';
import 'classes/globals.dart' as globals;
import 'classes/club.dart';

class SignUp extends StatefulWidget {

  List<Club> clubs;

  SignUp({this.clubs});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 12.0);
  EdgeInsets padding = EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0);

  String birthDateValue = "Select a date...";
  String genderValue;
  int handicapValue;
  Club clubSelection;

  // List<Club> widget.clubs = <Club>[new Club(name: "Marnong"), new Club(name: "Crib")];


  void setGenderCallback(String gender) {
    genderValue = gender;
  }

  void setClubCallback(Object clubName) {
    clubSelection = widget.clubs.firstWhere((element) => element.name == clubName);
  }

  void setHandicapCallback(Object handicap) {
    handicapValue = handicap;
  }

  @override
  Widget build(BuildContext context) {
    
    TextEditingController firstNameController = new TextEditingController();
    TextEditingController lastNameController = new TextEditingController();
    TextEditingController emailController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Please Sign Up",
          style: TextStyle(color: Colors.black),
        ),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // SizedBox(
                //   height: 5.0,
                // ),
                TextField(
                  controller: firstNameController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: padding,
                    hintText: "First Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: lastNameController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: padding,
                    hintText: "Last Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: emailController,
                  obscureText: false,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: padding,
                    hintText: "Email",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: style,
                  decoration: InputDecoration(
                    contentPadding: padding,
                    hintText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20.0,
                    ),
                    Text("Birth Date: "),
                    SizedBox(
                      width: 50.0,
                    ),
                    MaterialButton(
                      child: Text(birthDateValue),
                      onPressed: () => DatePicker.showDatePicker(
                        context,
                        minDateTime: new DateTime(1900),
                        maxDateTime: new DateTime(2100),
                        initialDateTime: new DateTime.now(), 
                        onConfirm: (dateTime, selectedIndex) {
                          birthDateValue = dateTime.toIso8601String();
                        },
                      ),
                    ), 
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                GenderSelection(
                  callback: setGenderCallback,
                ),
                SizedBox(
                  height: 8.0,
                ),
                ArrowSelection(
                  title: "Handicap: ", 
                  items: [for(var i=0; i<27; i+=1) i], 
                  itemIndex: 19, 
                  callback: setHandicapCallback
                ),
                SizedBox(
                  height: 8.0,
                ),
                ArrowSelection(
                  title: "Club: ", 
                  items: widget.clubs.map((e) => e.name).toList(), 
                  itemIndex: 0, 
                  callback: setClubCallback
                ),
                SizedBox(
                  height: 20.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green[300],
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: padding,
                    onPressed: () async {
                      // Future result = login(emailController.text, passwordController.text);
                      Future result = GraphQLUtils.addUser(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text, 
                        passwordController.text,
                        birthDateValue,
                        genderValue,
                        handicapValue,
                        clubSelection.id
                      );
                      result.then((data) {
                        if (data != null) {
                          print("Create user Success!");
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    child: Text("Sign Up",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

              ],
            )
          ),
        ),
      ),
    );
  }
}