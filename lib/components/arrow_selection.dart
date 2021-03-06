import 'package:flutter/material.dart';

import '../classes/export.dart';
import '../components/export.dart';
import '../utils/export.dart';
import '../user/export.dart';
import '../game/export.dart';

import '../globals.dart' as globals;


class ArrowSelection extends StatefulWidget {

  final String title;
  final List<Object> items;
  int itemIndex;
  Function callback;

  // ArrowSelection({this.title, this.items, this.itemIndex, this.callback});
  ArrowSelection({required this.title, required this.items, required this.itemIndex, required this.callback});

  @override
  ArrowSelectionState createState() => ArrowSelectionState(this.title, this.items, this.itemIndex);

}

class ArrowSelectionState extends State<ArrowSelection> {

  String title;
  List<Object> items;

  int itemIndex;

  ArrowSelectionState(this.title, this.items, this.itemIndex);

  void updateItemIndex(int index) {
    setState(() {
      this.itemIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Text(title),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              minWidth: 5,
              child: Icon(Icons.arrow_left),
              onPressed: () {
                if (itemIndex > 0) {
                  setState(() {
                    itemIndex -= 1;
                  });
                  widget.callback(items.elementAt(itemIndex));
                }
              },
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              child: Text(items.elementAt(itemIndex).toString()),
              onPressed: () {
                print("dummy button pressed");
              }
          ),
        ),
        Flexible(
          flex: 1,
          child: MaterialButton(
              minWidth: 5,
              child: Icon(Icons.arrow_right),
              onPressed: () {
                if (itemIndex < (items.length-1)) {
                  setState(() {
                    itemIndex += 1;
                  });
                  widget.callback(items.elementAt(itemIndex));
                }
              },
          ),
        ),
      ],
    );
  }
}
