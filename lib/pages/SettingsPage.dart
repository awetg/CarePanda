import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/main.dart';
import 'package:carePanda/widgets/HRLoginPopup.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/Theme.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/widgets/ReportBugPopup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/widgets/UserDataPopup.dart';
import 'package:carePanda/widgets/CardWidget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  //SettingsPage({Key key}) : super(key: key);
  final VoidCallback refreshNavBar;

  SettingsPage({this.refreshNavBar});

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  var _storageService = locator<LocalStorageService>();
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  // When user closes popup, changes layout and shows snackbar if user logged in successfully
  _loginPopupClosed() {
    setState(
      () {
        user = FirebaseAuth.instance.currentUser;
        if (!(user == null)) {
          _createSnackBar(getTranslated(context, "settings_successfulLogin"));
          widget.refreshNavBar();
        }
      },
    );
  }

  // Changes layout and displays snackbar as user logs out
  _logout() async {
    await FirebaseAuth.instance.signOut().then((value) => {
          setState(() {
            user = FirebaseAuth.instance.currentUser;
          }),
          _createSnackBar(getTranslated(context, "settings_successfulLogout")),
          widget.refreshNavBar(),
        });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          getTranslated(context, "settings_title"),
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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

            Padding(
              padding: const EdgeInsets.only(right: 14, left: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    child: Text(getTranslated(context, "settings_reportBugBtn"),
                        style: TextStyle(fontSize: 18)),
                    textColor: Theme.of(context).accentColor,
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {
                      showDialog(
                        barrierColor: _storageService.darkTheme
                            ? Colors.black.withOpacity(0.4)
                            : null,
                        context: context,
                        builder: (BuildContext context) {
                          return ReportBugPopup();
                        },
                      );
                    },
                  ),

                  // HR login button
                  if ((user == null))
                    OutlineButton(
                      child: Text(getTranslated(context, "settings_loginBtn"),
                          style: TextStyle(fontSize: 18)),
                      textColor: Theme.of(context).accentColor,
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        showDialog(
                          barrierColor: _storageService.darkTheme
                              ? Colors.black.withOpacity(0.4)
                              : null,
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return HRLoginPopup();
                          },
                        ).then((_) => _loginPopupClosed());
                      },
                    ),

                  // HR logout button
                  if (!(user == null))
                    OutlineButton(
                      child: Text(getTranslated(context, "settings_logoutBtn"),
                          style: TextStyle(fontSize: 18)),
                      textColor: Theme.of(context).accentColor,
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                      onPressed: () {
                        _logout();
                      },
                    ),
                ],
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
  var _dropdownValueLanguage;
  List<Language> languagesList;
  var _storageService = locator<LocalStorageService>();

  @override
  didChangeDependencies() {
    languagesList = <Language>[
      new Language(1, getTranslated(context, "settings_languageEn"), "en"),
      new Language(2, getTranslated(context, "settings_languageFi"), "fi")
    ];
    _getCurrentLanguage();
    super.didChangeDependencies();
  }

  _getCurrentLanguage() {
    var _languageCode = _storageService.language ?? "en";
    switch (_languageCode) {
      case "en":
        _dropdownValueLanguage = languagesList[0];
        break;
      case "fi":
        _dropdownValueLanguage = languagesList[1];
        break;
      default:
        _dropdownValueLanguage = languagesList[0];
    }
  }

  _changeLanguage(newLanguage) {
    Locale _newLocale;
    switch (newLanguage.countryCode) {
      case "en":
        _newLocale = Locale('en', '');
        break;
      case "fi":
        _newLocale = Locale('fi', '');
        break;
      default:
        _newLocale = Locale('en', '');
        break;
    }
    setState(() {
      _dropdownValueLanguage = newLanguage;
    });
    MyApp.setLocale(context, _newLocale);
  }

  @override
  Widget build(BuildContext context) {
    final _themeChanger = Provider.of<ThemeChanger>(context);
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(
            getTranslated(context, 'settings_appSettings'),
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor),
          ),
          SizedBox(height: 6),

          // Language
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              getTranslated(context, "settings_language"),
              style: TextStyle(fontSize: 20.0),
            ),
            DropdownButton<Language>(
              value: _dropdownValueLanguage,
              underline: Container(
                height: 1.5,
              ),
              onChanged: (Language newValue) {
                _changeLanguage(newValue);
              },
              items: languagesList.map((Language language) {
                return new DropdownMenuItem<Language>(
                  value: language,
                  child: Text(
                    language.name,
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
                getTranslated(context, "settings_darkTheme"),
                style: TextStyle(fontSize: 20.0),
              ),
              Switch(
                value: locator<LocalStorageService>().darkTheme ?? false,
                onChanged: (value) {
                  if (!value) {
                    _themeChanger.setTheme(ThemeType.Light);
                  } else {
                    _themeChanger.setTheme(ThemeType.Dark);
                  }
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
  var _storageService = locator<LocalStorageService>();

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
            getTranslated(context, "settings_notifSettings"),
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
                getTranslated(context, "settings_notif"),
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
            getTranslated(context, "settings_userSettings"),
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
                getTranslated(context, "settings_personalData"),
                style: TextStyle(fontSize: 20.0),
              ),
              OutlineButton(
                child: Text(getTranslated(context, "settings_modifyBtn"),
                    style: TextStyle(fontSize: 18)),
                textColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => UserDataPopup()));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Language {
  final int id;
  final String name;
  final String countryCode;

  Language(this.id, this.name, this.countryCode);
}
