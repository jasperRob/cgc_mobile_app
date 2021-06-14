import 'package:flutter/material.dart';
import 'invite_page.dart';
import '../classes/user.dart';
import '../classes/globals.dart' as globals;

class PlayerSelector extends StatefulWidget {

  String title;
  int playerIndex;
  bool disabled = false;
  Function(User, int) callback = null;
  User initPlayer = null;
  List<User> alreadySelected;

  PlayerSelector({this.title, this.playerIndex, this.callback, this.initPlayer, this.disabled, this.alreadySelected});

  @override
  PlayerSelectorState createState() => PlayerSelectorState(player: initPlayer);
}

class PlayerSelectorState extends State<PlayerSelector> {

  User player = null;

  PlayerSelectorState({this.player});

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(widget.title),
        SizedBox(width: 20,),
        MaterialButton(
          child: player == null ? Icon(Icons.add) : Text(player.fullName()),
          onPressed: widget.disabled ? null : () async {
            if (player == null) {
              Future<dynamic> playerResult = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvitePage(alreadySelected: widget.alreadySelected),
                )
              );
              playerResult.then((value) {
                setState(() {
                  player = value;
                });
                widget.callback(value, widget.playerIndex);
              }).catchError((error) {
                print(error);
              });
            } else {
              // Remove the player
              widget.callback(null, widget.playerIndex);
              setState(() {
                  player = null;
              });
            }
          },
        )
      ],
    );
  }
}
