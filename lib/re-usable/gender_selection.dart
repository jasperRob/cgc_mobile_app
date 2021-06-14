import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {

  String genderValue;
  Function(String) callback;

  GenderSelection({this.callback});

  @override
  GenderSelectionState createState() => GenderSelectionState();

}

class GenderSelectionState extends State<GenderSelection> {

  @override
  Widget build(BuildContext context) {


    return Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        Text("Gender: "),
        SizedBox(
          width: 10.0,
        ),
        MaterialButton(
          child: Text("Male"),
          padding: EdgeInsets.all(12),
          minWidth: 0,
          textColor: widget.genderValue=="Male" ? Colors.black : Colors.grey,
          onPressed: () {
            setState(() {
              widget.genderValue = "Male";
            });
            widget.callback("Male");
          },
        ), 
        MaterialButton(
          child: Text("Female"),
          padding: EdgeInsets.all(12),
          minWidth: 0,
          textColor: widget.genderValue=="Female" ? Colors.black : Colors.grey,
          onPressed: () {
            setState(() {
              widget.genderValue = "Female";
            });
            widget.callback("Female");
          },
        ), 
        MaterialButton(
          child: Text("Other"),
          padding: EdgeInsets.all(12),
          minWidth: 0,
          textColor: widget.genderValue=="Other" ? Colors.black : Colors.grey,
          onPressed: () {
            setState(() {
              widget.genderValue = "Other";
            });
            widget.callback("Other");
          },
        ), 
      ],
    );
  }
}

