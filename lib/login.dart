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


// Future<List<User>> fetchFriends() async {

//   var response = await http.get(Uri.parse('http://localhost:8080/user/friends?user_id=f1f4c25a-c9d1-11eb-b2a2-acde48001122'));
//   List<User> users;

//   users=(json.decode(response.body) as List).map((i) =>
//                 User.fromJSON(i)).toList();
//   return users;
// }

Future<dynamic> login(String email, String password) async {
  
  final response =
      await http.get(Uri.parse('http://localhost:8080/login?email=jasper.robison@gmail.com&password=test'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
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
          Future<dynamic> data = login("jasper.robison@gmail.com", "test");
          data.then((body){
            print(body);
            globals.token = body["token"];
            globals.user = User.fromJSON(body["user"]);
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
