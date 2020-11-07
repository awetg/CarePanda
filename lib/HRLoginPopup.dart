import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/main.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HRLoginPopup extends StatefulWidget {
  @override
  _HRLoginPopupState createState() => _HRLoginPopupState();
}

class _HRLoginPopupState extends State<HRLoginPopup> {
  final _blueColor = Color(0xff027DC5);
  var _username;
  var _password;

  login() {
    var _storageService = locator<LocalStorageService>();
    _storageService.isLoggedIn = true;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Center(child: Text("HR Login", style: TextStyle(color: _blueColor))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: TextFormField(
              onChanged: (username) {
                _username = username;
              },
              style: TextStyle(
                color: _blueColor,
              ),
              decoration: new InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(
                  color: _blueColor,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _blueColor, width: 1.5),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),

          // Password
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: TextFormField(
              onChanged: (password) {
                _password = password;
              },
              style: TextStyle(
                color: _blueColor,
              ),
              decoration: new InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(
                  color: _blueColor,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: _blueColor, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text("Cancel", style: TextStyle(fontSize: 18)),
          textColor: _blueColor,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: const Text('Login', style: TextStyle(fontSize: 18)),
          color: _blueColor,
          textColor: Colors.white,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            login();
          },
        ),
      ],
    );
  }
}
