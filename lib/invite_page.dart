import 'package:flutter/material.dart';
import '../classes/user.dart';
import '../classes/globals.dart' as globals;

import 'utils.dart';

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
            child: FutureBuilder<List<dynamic>>(
              future: Utils.fetchFriends(globals.user.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
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
                                ),
                                MaterialButton(
                                  child: Text("Invite"),
                                  onPressed: userAlreadySelected(snapshot.data[index]) ? null : () {
                                    widget.callback(snapshot.data[index]);
                                    Navigator.of(context).pop();
                                  }
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
