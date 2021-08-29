import 'package:flutter/material.dart';
import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


class PlayerSelector extends StatefulWidget {

  String title;
  int playerIndex;
  bool disabled = false;
  Function(User, int) callback;
  User initPlayer;
  List<User> alreadySelected;

  PlayerSelector({required this.title, required this.playerIndex, required this.callback, required this.initPlayer, required this.disabled, required this.alreadySelected});

  @override
  PlayerSelectorState createState() => PlayerSelectorState(player: initPlayer);
}

class PlayerSelectorState extends State<PlayerSelector> {

  User player;

  PlayerSelectorState({required this.player});

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
            // if (player == null) {
            //   Future<dynamic> playerResult = await Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => InvitePage(alreadySelected: widget.alreadySelected),
            //     )
            //   );
            //   playerResult.then((value) {
            //     setState(() {
            //       player = value;
            //     });
            //     widget.callback(value, widget.playerIndex);
            //   }).catchError((error) {
            //     print(error);
            //   });
            // } else {
            //   // Remove the player
            //   widget.callback(null, widget.playerIndex);
            //   setState(() {
            //       player = null;
            //   });
            // }
          },
        )
      ],
    );
  }
}
