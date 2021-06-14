import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../classes/user.dart';
import '../classes/globals.dart' as globals;

class InvitePage extends StatefulWidget {

  List<User> alreadySelected;

  InvitePage({this.alreadySelected});

  @override
  InvitePageState createState() => InvitePageState();

}

class InvitePageState extends State<InvitePage> {

  String token;
  static String userId = globals.user.id;

  final String queryString = """
    query {
      acceptedFriendsByUserId(id: \"$userId\") {
        id
        firstName
        lastName
      }
    }
    """;

  getToken() async {
    await globals.storage.read(key: "token")
    .then((value) {
      setState(() {
        token = "Bearer " + value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
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
          GraphQLProvider(
            child: Expanded(
              child: Query(
                options: QueryOptions(
                  documentNode: gql(queryString)
                ),
                builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {
                  VoidCallback refetchQuery = refetch;
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }
                  if (result.loading) {
                    return Text("Loading");
                  }
                  final List<User> users = <User>[];
                  print(result.data);
                  for (var item in result.data["acceptedFriendsByUserId"]) {
                    if (item != null) {
                      users.add(User.fromJSON(item));
                    }
                  }
                  print(users);
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      bool disabled = false;
                      for (User user in widget.alreadySelected) {
                        if (users[index].id == user.id) {
                          disabled = true;
                          break;
                        }
                      }
                      return ListTile(
                        title: Text(users[index].firstName + " " + users[index].lastName),
                        trailing: MaterialButton(
                          child: Text("Invite"),
                          onPressed: disabled ? null : () {
                            Navigator.of(context).pop(Future.value(users.elementAt(index)));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            client: ValueNotifier(
              GraphQLClient(
                cache: InMemoryCache(),
                link: HttpLink(
                  uri: globals.uri,
                  headers: {
                    "Authorization": token
                  },
                ),
              )
            ),
          ),
        ],
      )
    );
  }
}