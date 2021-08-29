import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;

const GET_USER = """
  query Query(\$nodeId: ID!) {
    node(id: \$nodeId) {
      ... on User {
        id
        firstName
        lastName
        email
        gender
        handicap
        totalGames
        club {
          id
          name
        }
      }
    }
  }
""";

class UserPage extends StatefulWidget {

  User user;
  UserPage({required this.user});

  @override
  UserPageState createState() => UserPageState(this.user);
}

class UserPageState extends State<UserPage> {

  User user;

  UserPageState(this.user);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(user.fullName()),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Query(
        options: QueryOptions(
            document: gql(GET_USER),
            variables: {
              "nodeId": user.graphqlID()
            },
            pollInterval: Duration(seconds: 10),
        ),
        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
          if (result.hasException) {
              return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return Text('Loading');
          }

          User user = User.fromJSON(result.data!["node"]);

          return Column(
            children: <Widget> [
              SizedBox(height: 30),
              Center(
                child: Row(children: [
                  Text("Email: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(user.email),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Gender: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(user.gender),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Handicap: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(user.handicap.toString()),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Total Games: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(user.totalGames.toString()),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Club: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(user.club.name),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
            ],
          );
        },
      )
    );
  }

}
