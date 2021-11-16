import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


const GET_USER_FRIENDS = '''
query Query(\$nodeId: ID!) {
  node(id: \$nodeId) {
    ... on User {
      friends {
        edges {
          node {
            id
            firstName
            lastName
          }
        }
      }
    }
  }
}
''';

class InvitePage extends StatefulWidget {

  Function(User) callback;
  List<User> selected;

  InvitePage({required this.callback, required this.selected});

  @override
  InvitePageState createState() => InvitePageState();

}

class InvitePageState extends State<InvitePage> {

  @override
  void initState() {
    super.initState();
  }

  bool userAlreadySelected(User user) {
    for (int i = 0; i < widget.selected.length; i++) {
      if (user.id == widget.selected[i].id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Invite a Player",
          style: TextStyle(color: Colors.black),
        ),
        leading: MaterialButton(
          child: Icon(Icons.arrow_back),
          onPressed: () async {
            Navigator.of(context).pop(Future.error("No User selected!"));
          },
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0.0, 0, 20.0, 0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                User newUser = User.dummyUser();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateGuestPage(widget.callback, newUser),
                  )
                );
              },
            ),
          ),
        ]
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.all(20.0),
              child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Search",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
          ),
          Container(
            child: Query(
              options: QueryOptions(
                  document: gql(Queries.GET_USER_FRIENDS),
                  variables: {
                    "nodeId": globals.user.graphqlID()
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

                List users = result.data!["node"]["friends"]["edges"];

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    // print("--------------");
                    // print(users[index]["node"]);
                    User user = User.fromJSON(users[index]["node"]);

                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(user.fullName()),
                            trailing: MaterialButton(
                              child: Text("Invite"),
                              onPressed: userAlreadySelected(user) ? null : () {
                                widget.callback(user);
                                Navigator.of(context).pop();
                              }
                            )
                          )
                        ],
                      ),
                    );
                });
              },
            )
          ),
        ],
      )
    );
  }
}
