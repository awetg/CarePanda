import 'dart:developer';
import 'dart:io';

import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/pages/HRdashboardPage.dart';
import 'package:carePanda/pages/HRmanagementPage.dart';
import 'package:carePanda/pages/userboarding/user_boarding.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/pages/HomePage.dart';
import 'package:carePanda/pages/DashboardPage.dart';
import 'package:carePanda/pages/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:carePanda/ServiceLocator.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Theme.dart';

bool showBoarding;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  var _storageService = locator<LocalStorageService>();
  showBoarding = _storageService.showBoarding ?? true;
  print("showBoarding = $showBoarding");

  if (_storageService.darkTheme == null) {
    _storageService.darkTheme = false;
  }
  runApp(Testing());
}

class Testing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  static void setLocale(context, locale) {
    _MyAppState state = context.findRootAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  var _storageService = locator<LocalStorageService>();

  // Function to change language and saves language code to shared preferences
  setLocale(locale) {
    setState(() {
      _locale = locale;
      _storageService.language = locale.languageCode;
    });
  }

  @override
  void didChangeDependencies() {
    // If user has not set language before (first start), uses user's phones language if it's either finnish or english
    // Defaults to english if users language is not supported
    if (_storageService.language == null) {
      var _usersLanguageOption = Platform.localeName;
      var _usersLanguageCode = _usersLanguageOption.substring(0, 2);
      log(_usersLanguageCode.toString());
      if (Localization.delegate.isSupported(Locale(_usersLanguageCode, ''))) {
        log("true");
        _storageService.language = _usersLanguageCode;
      } else {
        log("false");
        _storageService.language = "en";
      }
    }

    // Gets language code from shared preference and depending on the language code,
    // chooses a language
    var _languageCode = _storageService.language;
    switch (_languageCode) {
      case "en":
        _locale = Locale(_languageCode, '');
        break;
      case "fi":
        _locale = Locale(_languageCode, '');
        break;
      default:
        _locale = Locale("en", '');
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Panda',
      theme: theme.getTheme(),
      locale: _locale,
      supportedLocales: [Locale('en', ''), Locale('fi', '')],
      localizationsDelegates: [
        Localization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in deviceLocale) {
          if (locale != null) {
            return locale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: showBoarding ? "/boarding" : "/",
      routes: {
        "/": (context) => MyStatefulWidget(),
        "/boarding": (context) => UserBoarding(),
      },
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidget createState() => _MyStatefulWidget();
}

class _MyStatefulWidget extends State<MyStatefulWidget> {
  var _isLoggedIn;
  var _storageService = locator<LocalStorageService>();
  int _selectedPage = 0;
  var _pageOptions;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = _storageService.isLoggedIn ?? false;

    _pageOptions = [
      HomePage(),
      DashBoardPage(),
      SettingsPage(
        // Callback which refreshes bottom navigation bar to show new icon for HR
        refreshNavBar: () {
          setState(
            () {
              _isLoggedIn = _storageService.isLoggedIn ?? false;
            },
          );
        },
      ),
      HRdashboardPage(),
      HRmanagementPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).accentIconTheme.color,
        selectedItemColor: Theme.of(context).accentColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: getTranslated(context, "bottomNavBar_home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: getTranslated(context, "bottomNavBar_dashboard")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: getTranslated(context, "bottomNavBar_settings")),
          if (_isLoggedIn)
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: getTranslated(context, "bottomNavBar_statistics")),
          if (_isLoggedIn)
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment),
                label: getTranslated(context, "bottomNavBar_admin")),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
