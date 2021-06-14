/* 
Login Page Widget

Provides a Login UI and handles frontend
login logic. Sends login request to the 
backend using GraphQL.

Authors: Jasper Robison
*/

import 'package:cgc_mobile_app/common.dart';
import 'package:cgc_mobile_app/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'classes/club.dart';
import 'classes/globals.dart' as globals;
import 'classes/graphql_utils.dart';
import 'main.dart';
import 'classes/user.dart';
import 'dart:convert';

class Login extends StatelessWidget {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    TextEditingController passwordController = new TextEditingController();
    final passwordField = TextField(
      controller: passwordController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green[300],
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          // Send Login request
          await GraphQLUtils.login("jasper.robison@gmail.com", "test")
          // await GraphQLUtils.login(emailController.text, passwordController.text) // USE THIS IN PRODUCTION
          .then((value) async {
            // Reteive token and store it
            String token = value.data['login']['token'];
            await globals.storage.write(key: "token", value: token.toString());
            // Send request for user data
            await GraphQLUtils.getUserData("jasper.robison@gmail.com")
            // await GraphQLUtils.getUserData(emailController.text)
            .then((value) async {
              // Store this user data
              globals.user = User.fromJSON(value.data['userByEmail']);
            })
            .catchError((error) {
              print("ERROR Getting user data");
              print(error);
            });
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Common(),
              )
            );
        
          })
          .catchError((error) {
            print("ERROR Logging in");
            print(error);
          });
        },
        child: Text("Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
    
    final signUpButton = MaterialButton(
      child: Text("Sign Up?",
        style: style.copyWith(fontSize: 14.0),
        
      ),
      onPressed: () async {
        // Navigator.of(context).pushNamed("/signup");
        await GraphQLUtils.getAllClubs()
        .catchError((error) {
          print(error);
        })
        .then((value) {
          List<Club> clubList = [];
          for (var item in value.data["allClubs"]["edges"]) {
            clubList.add(Club.fromJSON(item["node"]));
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(clubs: clubList),
            )
          );
        });
      },
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  child: Text("Please Login", style: style,)
                ),
                SizedBox(
                  height: 45.0,
                ),
                emailField,
                SizedBox(
                  height: 25.0,
                ),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 45.0,
                ),
                signUpButton,
              ],
            )
          ),
        ),
      ),
    );
  }
}