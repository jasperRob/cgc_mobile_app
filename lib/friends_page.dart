/* 
The contents of the common page body 
when home page is the active state
*/
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'classes/globals.dart' as globals;
import 'classes/user.dart';
import 'utils.dart';

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

  Future<List<User>> fetchAndSaveFriends(String userId) async {
    
    List<User> friends = await Utils.fetchFriends(userId);
    List<User> requested = await Utils.fetchRequested(userId);
    List<User> requests = await Utils.fetchRequests(userId);

    setState(() {
      widget.friends = friends;
      widget.requested = requested;
      widget.requests = requests;
    });

    // Put Requests at front
    List<User> data = new List.from(requests)..addAll(friends);
    return data;
  }

  bool isFriend(User user) {
    for (User friend in widget.friends) {
      if (user.id == friend.id) {
        return true;
      }
    }
  return false;
  }

  bool isRequested(User user) {
    for (User friend in widget.requested) {
      if (user.id == friend.id) {
        return true;
      }
    }
  return false;
  }

  bool isRequest(User user) {
    for (User friend in widget.requests) {
      if (user.id == friend.id) {
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
            child: FutureBuilder<List<dynamic>>(
              future: widget.searchActive ? Utils.searchUsers(widget.keyword) : fetchAndSaveFriends(globals.user.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  // Filter out the current user
                  snapshot.data.removeWhere((user) => user.id == globals.user.id);
                  return snapshot.data.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index){
                        return
                          Card(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(snapshot.data[index].fullName()),
                                  trailing: isFriend(snapshot.data[index]) ? null 
                                    : isRequested(snapshot.data[index]) ? Text("Pending") 
                                    : isRequest(snapshot.data[index])
                                    ? MaterialButton(
                                    child: Text("Accept"),
                                    onPressed: () async {
                                      Utils.acceptFriendship(globals.user.id, snapshot.data[index].id);
                                      await fetchAndSaveFriends(globals.user.id);
                                    })
                                    : MaterialButton(
                                    child: Text("Add"),
                                    onPressed: () async {
                                      Utils.postFriendship(globals.user.id, snapshot.data[index].id);
                                      await fetchAndSaveFriends(globals.user.id);
                                    }
                                  )
                                )
                              ],
                            ),
                          );
                      })
                    : Center(child: Text("No Friends to show"));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      )
    );
  }
}
