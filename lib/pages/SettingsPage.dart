import 'dart:developer';

import 'package:carePanda/HRLoginPopup.dart';
import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/UserDataPopup.dart';
import 'package:carePanda/CardWidget.dart';

final _lightColor = Color(0xffA0C3E2);
final _blueColor = Color(0xff027DC5);

class SettingsPage extends StatefulWidget {
  //SettingsPage({Key key}) : super(key: key);
  final VoidCallback refreshNavBar;

  SettingsPage({this.refreshNavBar});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  var _isLoggedIn;
  var _storageService = locator<LocalStorageService>();

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _storageService.isLoggedIn ?? false;
  }

  // When user closes popup, changes layout and shows snackbar if user logged in successfully
  _loginPopupClosed() {
    setState(
      () {
        _isLoggedIn = _storageService.isLoggedIn;
        if (_isLoggedIn) {
          _createSnackBar("Successfully logged in");
          widget.refreshNavBar();
        }
      },
    );
  }

  // Changes layout and displays snackbar as user logs out
  _logout() {
    setState(
      () {
        _storageService.isLoggedIn = false;
        _isLoggedIn = _storageService.isLoggedIn;
        _createSnackBar("Successfully logged out");
        widget.refreshNavBar();
      },
    );
  }

  // Creates snackbar with given message
  _createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: _blueColor);

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title: const Text('Settings',
                style: TextStyle(color: Color(0xff027DC5)))),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // App settings
              CardWidget(widget: AppSettings()),
              SizedBox(height: 14),

              // Notification settings
              CardWidget(widget: NotificationSettings()),
              SizedBox(height: 14),

              // User settings
              CardWidget(widget: UserSettings()),
              SizedBox(height: 18),

              // HR login button
              if (!_isLoggedIn)
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: OutlineButton(
                    child: const Text('HR', style: TextStyle(fontSize: 18)),
                    textColor: _blueColor,
                    splashColor: Color(0xffD7E0EB),
                    borderSide: BorderSide(
                      color: _blueColor,
                    ),
                    onPressed: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return HRLoginPopup();
                        },
                      ).then((_) => _loginPopupClosed());
                    },
                  ),
                ),

              // HR logout button
              if (_isLoggedIn)
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: OutlineButton(
                    child: const Text('Logout', style: TextStyle(fontSize: 18)),
                    textColor: _blueColor,
                    splashColor: Color(0xffD7E0EB),
                    borderSide: BorderSide(
                      color: _blueColor,
                    ),
                    onPressed: () {
                      _logout();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  String dropdownValue = 'English';
  String themeValue = 'Light';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'App Settings',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold, color: _blueColor),
          ),
          SizedBox(height: 6),

          // Language
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Language',
              style: TextStyle(fontSize: 20.0),
            ),
            DropdownButton<String>(
              value: dropdownValue,
              //style: TextStyle(color: _blueColor),
              underline: Container(
                height: 1.5,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['English', 'Swedish', 'Finnish']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 20.0),
                  ),
                );
              }).toList(),
            )
          ]),

          // Theme
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Theme',
                style: TextStyle(fontSize: 20.0),
              ),
              DropdownButton<String>(
                value: themeValue,
                //style: TextStyle(color: _blueColor),
                underline: Container(
                  height: 1.5,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    themeValue = newValue;
                  });
                },
                items: <String>['Light', 'Dark']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 20.0)),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Notification Settings',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold, color: _blueColor),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Notifications',
                style: TextStyle(fontSize: 20.0),
              ),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: _lightColor,
                activeColor: _blueColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserSettings extends StatefulWidget {
  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'User Settings',
            style: TextStyle(
                fontSize: 20.0, fontWeight: FontWeight.bold, color: _blueColor),
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Personal data',
                style: TextStyle(fontSize: 20.0),
              ),
              OutlineButton(
                child: const Text('Modify', style: TextStyle(fontSize: 18)),
                textColor: _blueColor,
                splashColor: Color(0xffD7E0EB),
                borderSide: BorderSide(
                  color: _blueColor,
                ),
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return UserDataPopup();
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
