import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter/services.dart';

class HRPopup extends StatefulWidget {
  @override
  _HRPopup createState() => _HRPopup();
}

class _HRPopup extends State<HRPopup> {
  final _blueColor = Color(0xff027DC5);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter your phone number and HR will contact you shortly",
          style: TextStyle(color: _blueColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: new InputDecoration(labelText: "Enter your number"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("* This feature not implemented in test version",
                  style: TextStyle(fontSize: 13.0, color: _blueColor)),
            ],
          )
        ],
      ),
      actions: [
        RaisedButton(
          child: const Text('Cancel', style: TextStyle(fontSize: 18)),
          color: _blueColor,
          textColor: Colors.white,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
          color: _blueColor,
          textColor: Colors.white,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
