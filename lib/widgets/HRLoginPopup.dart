import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';

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
      contentPadding: EdgeInsets.only(top: 26, left: 10, right: 10, bottom: 14),
      title: Center(
          child: Text(getTranslated(context, "hrLogin_title"),
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
                decoration: InputDecoration(
                  labelText: getTranslated(context, "hrLogin_usernameTxtfield"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
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
                obscureText: true,
                decoration: new InputDecoration(
                  labelText: getTranslated(context, "hrLogin_passwordTxtfield"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
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
          child: Text(getTranslated(context, "cancelBtn"),
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).accentColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text(getTranslated(context, "hrLogin_loginBtn"),
              style: TextStyle(fontSize: 18)),
          onPressed: () {
            login();
          },
        ),
      ],
    );
  }
}
