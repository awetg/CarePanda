import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class HRLoginPopup extends StatefulWidget {
  @override
  _HRLoginPopupState createState() => _HRLoginPopupState();
}

class _HRLoginPopupState extends State<HRLoginPopup> {
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
      title: Center(
          child: Text("HR Login",
              style: TextStyle(color: Theme.of(context).accentColor))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: TextFormField(
                onChanged: (username) {
                  _username = username;
                },
                decoration: new InputDecoration(
                  labelText: "Username",
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        width: 1.5),
                  ),
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
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: TextFormField(
                onChanged: (password) {
                  _password = password;
                },
                decoration: new InputDecoration(
                  labelText: "Password",
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).textTheme.bodyText1.color,
                        width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text("Cancel",
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).accentColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: const Text('Login', style: TextStyle(fontSize: 18)),
          onPressed: () {
            login();
          },
        ),
      ],
    );
  }
}
