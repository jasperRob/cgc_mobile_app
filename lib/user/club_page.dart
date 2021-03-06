import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


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
            document: gql(Queries.GET_CLUB),
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
            // return Text('Loading');
            return LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: const [Colors.grey],
                strokeWidth: 2,
            );
          }

          Club club = Club.fromJSON(result.data!["node"]);

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
                  Text(Utils.orNA(club.email)),
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
                  Text(Utils.orNA(club.phone)),
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
                  Text(Utils.orNA(club.address)),
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
                  Text(Utils.orNA(club.city)),
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
                  Text(Utils.orNA(club.state)),
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
                  Text(Utils.orNA(club.country)),
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
                  Text(Utils.orNA(club.zipCode)),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Current Wind Direction: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(Utils.orNA(club.windDirection)),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center
                )
              ),
              SizedBox(height: 20),
              Center(
                child: Row(children: [
                  Text("Current Wind Strength: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                  )),
                  SizedBox(width: 20),
                  Text(Utils.orNADouble(club.windStrength)),
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
