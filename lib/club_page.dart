import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'classes/game.dart';
import 'classes/hole.dart';
import 'classes/score.dart';
import 'classes/club.dart';
import 're-usable/arrow_selection.dart';
import 'classes/globals.dart' as globals;
// import 'hole_view.dart';
import 'hole_page.dart';

import 'utils.dart';

const GET_CLUB = """
  query Query(\$nodeId: ID!) {
    node(id: \$nodeId) {
      ... on Club {
        id
        email
        phone
        address
        city
        state
        country
        zipCode
      }
    }
  }
""";

class ClubPage extends StatefulWidget {

  Club club;
  ClubPage({required this.club});

  @override
  ClubPageState createState() => ClubPageState(this.club);
}

class ClubPageState extends State<ClubPage> {

  Club club;

  ClubPageState(this.club);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Query(
        options: QueryOptions(
            document: gql(GET_CLUB),
            variables: {
              "nodeId": club.graphqlID()
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

          print(result.data!["node"]);
          Club club = Club.fromJSON(result.data!["node"]);
          print(club.email);
          print(club.phone);
          print(club.address);
          print(club.city);
          print(club.state);
          print(club.country);
          print(club.zipCode);

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
                  Text(club.email),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Phone: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.phone),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Address: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.address),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("City: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.city),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("State: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.state),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Country: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.country),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Zip Code: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(club.zipCode),
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
