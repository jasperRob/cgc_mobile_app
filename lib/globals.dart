library cgc_mobile_app.globals;

import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/user.dart';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

// AUTH0 Details
const String AUTH0_DOMAIN = 'compactgolfcourse.au.auth0.com';
const String AUTH0_CLIENT_ID = 'n2d9HUh7nhCKFCnrA2ydhKmEufzp2KiD';

const String AUTH0_REDIRECT_URI = 'com.gada.compactgolfcourse://login-callback';
const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

// Colours and Styles
final Color? primaryDarkColor = Colors.grey[800];
final Color? primaryLightColor = Colors.white;
final Color? secondaryColor = Color.fromRGBO(215, 188, 141, 1.0);

TextStyle loginStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
TextStyle guestStyle = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
EdgeInsets padding = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
BorderRadius radius = BorderRadius.circular(5);

// Other Globals
String? token = "";

GraphQLClient client = GraphQLClient(
  link: HttpLink(
    // 'http://127.0.0.1:4000/graphql',
    'https://cgc-api.gada.io/graphql',
  ),
  cache: GraphQLCache(),
);

// Init user as blank placeholder
User user = User.dummyUser();

late LocationData locationData;
