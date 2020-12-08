import 'dart:io';
import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementPage.dart';
import 'package:carePanda/pages/dashboard/DashboardPage.dart';
import 'package:carePanda/pages/dashboard/HRdashboardPage.dart';
import 'package:carePanda/pages/userboarding/user_boarding.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/pages/HomePage.dart';
import 'package:carePanda/pages/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'services/Theme.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initiliaze dotenv
  await DotEnv().load('.env');
  // initiliaze core firebase
  await Firebase.initializeApp();
  // start local storage service
  await startStorageService();
  final _storageService = locator<LocalStorageService>();
  final String userId = _storageService.anonymousUserId ?? null;
  // set if userId not set
  if (userId == null) {
    _storageService.anonymousUserId = Uuid().v4();
  }

  if (_storageService.darkTheme == null) {
    _storageService.darkTheme = false;
  }
  // start all other services
  await setupLocator();

  runApp(ChangeNotifierProvider<ThemeChanger>(
    create: (_) => ThemeChanger(),
    child: MyApp(),
  ));
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
      if (Localization.delegate.isSupported(Locale(_usersLanguageCode, ''))) {
        _storageService.language = _usersLanguageCode;
      } else {
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Panda',
      theme: Provider.of<ThemeChanger>(context).getTheme(),
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
      initialRoute:
          _storageService.firstTimeStartUp ?? true ? "/boarding" : "/app",
      routes: {
        "/boarding": (context) => UserBoarding(),
        "/app": (context) => AppNavigation(),
      },
    );
  }
}

class AppNavigation extends StatefulWidget {
  AppNavigation({Key key}) : super(key: key);

  @override
  _AppNavigation createState() => _AppNavigation();
}

class _AppNavigation extends State<AppNavigation> {
  int _selectedPage = 0;
  var _pageOptions;
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _pageOptions = [
      HomePage(),
      DashBoardPage(),
      SettingsPage(
        // Callback which refreshes bottom navigation bar to show new icon for HR
        refreshNavBar: () {
          setState(
            () {
              user = FirebaseAuth.instance.currentUser;
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
          if (!(user == null))
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: getTranslated(context, "bottomNavBar_statistics")),
          if (!(user == null))
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
