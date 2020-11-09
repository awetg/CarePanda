import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HRPopup extends StatefulWidget {
  @override
  _HRPopup createState() => _HRPopup();
}

class _HRPopup extends State<HRPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter your phone number and HR will contact you shortly",
          style: TextStyle(color: Theme.of(context).accentColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Theme(
            data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
            child: TextField(
              decoration: new InputDecoration(labelText: "Enter your number"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("* This feature not implemented in test version",
                  style: TextStyle(
                      fontSize: 13.0, color: Theme.of(context).accentColor)),
            ],
          )
        ],
      ),
      actions: [
        FlatButton(
          child: Text("Cancel", style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
