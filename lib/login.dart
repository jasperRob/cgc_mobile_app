/* 
Login Page Widget

Provides a Login UI and handles frontend
login logic. Sends login request to the 
backend using GraphQL.

Authors: Jasper Robison
*/

import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'main.dart';
import 'common.dart';
import 'classes/globals.dart' as globals;
import 'classes/user.dart';
// import 'utils.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';

Future<dynamic> login(String userEmail, String password) async {

  const GET_USER_BY_EMAIL = """
  query Query {
    userByEmail(email: "test.person@test.com") {
      id
      firstName
      lastName
      email
      birthDate
      gender
      handicap
      totalGames
      admin
      club {
        id
        name
      }
      friends {
        edges {
          node {
            id
          }
        }
      }
    }
  }""";


  QueryOptions queryOptions = QueryOptions(
    document: gql(GET_USER_BY_EMAIL)
  );

  dynamic result = await globals.client.query(queryOptions);

  return result.data["userByEmail"];
}

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
          print("LOGGIN IN");
          Future<dynamic> data = login("test.person@test.com", "test");
          data.then((body){
            print("HERE");
            print(body);
            globals.user = User.fromJSON(body);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Common(),
              )
            );
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
        print("HERE");
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
