import 'package:carePanda/HRLoginPopup.dart';
import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/Theme.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/UserDataPopup.dart';
import 'package:carePanda/CardWidget.dart';
import 'dart:developer';

import 'package:provider/provider.dart';

var _storageService = locator<LocalStorageService>();

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
        _isLoggedIn = _storageService.isLoggedIn ?? false;
      },
    );
    if (_isLoggedIn) {
      _createSnackBar("Successfully logged in");
      widget.refreshNavBar();
    }
  }

  // Changes layout and displays snackbar as user logs out
  _logout() {
    setState(
      () {
        _storageService.isLoggedIn = false;
        _isLoggedIn = _storageService.isLoggedIn;
      },
    );
    _createSnackBar("Successfully logged out");
    widget.refreshNavBar();
  }

  // Creates snackbar with given message
  _createSnackBar(String message) {
    final snackBar = new SnackBar(
        content: new Text(message),
        backgroundColor: Theme.of(context).accentColor);

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    log(Theme.of(context).primaryColor.toString());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
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
                  textColor: Theme.of(context).accentColor,
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
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
                  textColor: Theme.of(context).accentColor,
                  borderSide: BorderSide(
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    _logout();
                  },
                ),
              ),
          ],
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
  String _dropdownValue = 'English';
  bool _darkTheme;

  @override
  void initState() {
    super.initState();

    _darkTheme = _storageService.darkTheme ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'App Settings',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
          SizedBox(height: 6),

          // Language
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              'Language',
              style: TextStyle(fontSize: 20.0),
            ),
            DropdownButton<String>(
              value: _dropdownValue,
              underline: Container(
                height: 1.5,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _dropdownValue = newValue;
                });
              },
              items: <String>['English', 'Swedish', 'Finnish']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 18.0),
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
                'Dark theme',
                style: TextStyle(fontSize: 20.0),
              ),
              Switch(
                value: _darkTheme,
                onChanged: (value) {
                  log(value.toString());
                  if (!value) {
                    _themeChanger.setTheme("Light");
                  } else {
                    _themeChanger.setTheme("Dark");
                  }
                  _darkTheme = value;
                },
                activeTrackColor: Theme.of(context).toggleableActiveColor,
                activeColor: Theme.of(context).accentColor,
              ),
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
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _isSwitched;

  @override
  void initState() {
    super.initState();
    _isSwitched = _storageService.recievePushNotif ?? true;
  }

  // Subscribes / unsubscribes to push notifications (uses topic to identify wheter to recieve push notifications or not)
  _togglePushNotif(value) {
    if (_storageService.recievePushNotif) {
      _storageService.recievePushNotif = false;
      _fcm.unsubscribeFromTopic('notifications');
    } else {
      _storageService.recievePushNotif = true;
      _fcm.subscribeToTopic('notifications');
    }

    setState(() {
      _isSwitched = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Notification Settings',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
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
                value: _isSwitched,
                onChanged: (value) {
                  _togglePushNotif(value);
                },
                activeTrackColor: Theme.of(context).toggleableActiveColor,
                activeColor: Theme.of(context).accentColor,
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
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
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
                textColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
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
