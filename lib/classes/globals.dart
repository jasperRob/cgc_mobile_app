library cgc_mobile_app.globals;

import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'user.dart';

String token = "";

GraphQLClient client = GraphQLClient(
  link: HttpLink(
    'http://127.0.0.1:4000/graphql',
  ),
  cache: GraphQLCache(),
);

User user = User(
  "null",
  "null",
  "null",
  "null",
  "null",
  "null",
  -1,
  -1,
  -1,
  [],
  []
);

