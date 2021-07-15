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
import 'package:flutter_appauth/flutter_appauth.dart';

final FlutterAppAuth appAuth = FlutterAppAuth();

Future<void> loginAction() async {

  try {
    String AUTH0_DOMAIN = globals.AUTH0_DOMAIN;
    final AuthorizationTokenResponse? result = await appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        globals.AUTH0_CLIENT_ID,
        globals.AUTH0_REDIRECT_URI,
        issuer: 'https://$AUTH0_DOMAIN',
        scopes: <String>['openid', 'profile', 'offline_access'],
        // promptValues: ['login']
      ),
    );

    globals.token = result!.accessToken;

  } on Exception catch (e, s) {
    print('login error: $e - stack: $s');
  }
}

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
        windDirection
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

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    final emailField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextField(
        controller: emailController,
        obscureText: false,
        style: globals.style,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );
    TextEditingController passwordController = new TextEditingController();
    final passwordField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextField(
        controller: emailController,
        obscureText: true,
        style: globals.style,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );

    final loginButton = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: Material(
        elevation: 5.0,
        borderRadius: globals.radius,
        color: globals.primaryDarkColor,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: globals.padding,
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
            style: globals.style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                    padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    alignment: Alignment(0.0, -0.5),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/marnong_estate_header_logo.png',
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width - 140,
                          //height: MediaQuery.of(context).size.height,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                ),
                emailField,
                SizedBox(
                  height: 10.0,
                ),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 45.0,
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
