import 'package:flutter/material.dart';
import 'package:carePanda/Pages/HomePage.dart' as home;
import 'package:carePanda/UserDataPopup.dart';

final _lightColor = Color(0xffA0C3E2);
final _blueColor = Color(0xff027DC5);

class SettingsPage extends StatelessWidget {
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
        body: SingleChildScrollView(child: MyStatefulWidget()),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

String dropdownValue = 'English';
String themeValue = 'Light';
bool isSwitched = true;

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final _lightColor = Color(0xffA0C3E2);
  final _blueColor = Color(0xff027DC5);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App settings
          home.CardWidget(widget: AppSettings()),
          SizedBox(height: 14),

          // Notification settings
          home.CardWidget(widget: NotificationSettings()),
          SizedBox(height: 14),

          // User settings
          home.CardWidget(widget: UserSettings()),
        ],
      ),
    );
  }
}

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'App Settings',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            'Notification Settings',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
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
