/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'classes/globals.dart' as globals;
import 'classes/user.dart';
import 'classes/req.dart';
import 'utils.dart';

import 'classes/queries.dart';
import 'classes/mutations.dart';

import 'user_page.dart';


Future<dynamic> fetchFriendsAndRequests(User user) async {


  QueryOptions queryOptions = QueryOptions(
    document: gql(Queries.GET_USER_FRIENDS),
    variables:{
      "nodeId": user.graphqlID(),
    }
  );

  dynamic result = await globals.client.query(queryOptions);

  return result.data["node"];
}

Future<void> createRequest(User source, User target) async {

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.CREATE_REQUEST),
    variables: {
      "requestFriendSourceId": source.id,
      "requestFriendTargetId": target.id
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);

}

Future<void> acceptRequest(Req request) async {

  MutationOptions mutationOptions = MutationOptions(
    document: gql(Mutations.ACCEPT_REQUEST),
    variables: {
      "acceptRequestRequestId": request.id,
    }
  );
  dynamic result = await globals.client.mutate(mutationOptions);
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class FriendsPage extends StatefulWidget{

  bool searchActive = false;
  String keyword = "";

  List<User> friends = [];
  List<User> requested = [];
  List<User> requests = [];

  FriendsPage();

  @override
  FriendsPageState createState() => FriendsPageState();

}


  
class FriendsPageState extends State<FriendsPage> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchAndSaveFriends() async {
    
    dynamic data = await fetchFriendsAndRequests(globals.user);

    List<User> friends = [];
    if (data["friends"] != null) {
      friends = new List<User>.from(data["friends"]["edges"].map((item) {
        return User.fromJSON(item["node"]);
      }));
    }

    List<Req> requests = [];
    if (data["requests"] != null) {
      requests = new List<Req>.from(data["requests"]["edges"].map((item) {
        return Req.fromJSON(item["node"]);
      }));
    }

    globals.user.friends = friends;
    globals.user.requests = requests;

  }

  bool isFriend(User user) {
    for (User friend in globals.user.friends) {
      if (user.id == friend.id) {
        return true;
      }
    }
  return false;
  }

  bool isRequested(User user) {
    for (Req req in globals.user.requests) {
      if (user.id == req.target.id) {
        return true;
      }
    }
  return false;
  }

  bool isRequest(User user) {
    for (Req req in globals.user.requests) {
      if (user.id == req.source.id) {
        return true;
      }
    }
  return false;
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
              onChanged: (value) {
                setState(() {
                  widget.keyword = value;
                  widget.searchActive = true;
                });
              }
            ),
          ),
          Container(
            child: Query(
              options: widget.searchActive ? QueryOptions(
                  document: gql(Queries.GET_USERS_BY_KEYWORD),
                  variables: {
                    "usersByKeywordKeyword": widget.keyword
                  },
                  pollInterval: Duration(seconds: 10),
              ) : QueryOptions(
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
                  return Text('Loading');
                }

                List users = [];
                if (result.data!["node"] != null) {
                  users = result.data!["node"]["friends"]["edges"];
                } else {
                  users = result.data!["usersByKeyword"];
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user;
                    if (users[index]["node"] != null) {
                      user = User.fromJSON(users[index]["node"]);
                    } else {
                      user = User.fromJSON(users[index]);
                    }

                    return Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(user.fullName()),
                            trailing: isFriend(user) ? MaterialButton(
                              child: Text("View"),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserPage(user: user),
                                  )
                                );
                              })
                              : isRequest(user)
                              ? MaterialButton(
                              child: Text("Accept"),
                              onPressed: () async {
                                // Utils.acceptFriendship(globals.user.id, user.id);

                                for (Req request in user.requests) {
                                  if (request.source.id == user.id && request.target.id == globals.user.id) {
                                    await acceptRequest(request);
                                    await fetchAndSaveFriends();
                                    widget.friends.add(user);
                                    break;
                                  }
                                }
                              })
                              : isRequested(user) ? Text("Pending") 
                              : MaterialButton(
                              child: Text("Add"),
                              onPressed: () async {
                                await createRequest(globals.user, user);
                                await fetchAndSaveFriends();
                                widget.requested.add(user);
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
