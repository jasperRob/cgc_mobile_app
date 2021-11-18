import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

import 'classes/export.dart';
import 'components/export.dart';
import 'utils/export.dart';
import 'user/export.dart';
import 'game/export.dart';

import 'globals.dart' as globals;

import 'common.dart';

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

  print("USEREMAIL = " + userEmail);

  QueryOptions queryOptions = QueryOptions(
    document: gql(Queries.GET_USER_BY_EMAIL),
    variables:{
      "userByEmailEmail": userEmail,
    }
  );

  dynamic result = await globals.client.query(queryOptions);

  return result.data["userByEmail"];

}

class Login extends StatelessWidget {

  static TextEditingController emailController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextFormField(
        controller: emailController,
        enableSuggestions: false,
        obscureText: false,
        textCapitalization: TextCapitalization.none,
        style: globals.loginStyle,
        decoration: InputDecoration(
          contentPadding: globals.padding,
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: globals.radius),
        ),
      ),
    );
    final passwordField = Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
      child: TextFormField(
        controller: passwordController,
        enableSuggestions: false,
        obscureText: true,
        textCapitalization: TextCapitalization.none,
        style: globals.loginStyle,
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
            // Future<dynamic> data = login(emailController.text, passwordController.text);
            Future<dynamic> data = login("jasper.robison@gada.io", passwordController.text);
            data.then((body){
              print("MY DETAILS:");
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
            style: globals.loginStyle.copyWith(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 70, vertical: 0),
                    // padding: EdgeInsets.fromLTRB(0, 120, 0, 0),
                    // alignment: Alignment(0.0, -0.5),
                    child: Image.asset(
                      'assets/images/marnong_estate_header_logo.png',
                      // alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width/2,
                      //height: MediaQuery.of(context).size.height,
                    )
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
