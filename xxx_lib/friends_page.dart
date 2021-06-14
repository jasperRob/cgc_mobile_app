/* 
The contents of the common page body 
when home page is the active state
*/
import 'classes/user.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'classes/globals.dart' as globals;


class FriendsPage extends StatefulWidget{

  FriendsPage();

  @override
  FriendsPageState createState() => FriendsPageState();

}
  
class FriendsPageState extends State<FriendsPage> {

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
  
  Widget build(BuildContext context) {
    return Scaffold(
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

                  for (var item in result.data["acceptedFriendsByUserId"]) {
                    users.add(User.fromJSON(item));
                  }
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(users[index].firstName + " " + users[index].lastName),
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
                  }
                )
              )
            ),
          )
        ],
      )
    );
  }
}
