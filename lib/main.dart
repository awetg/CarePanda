import 'dart:developer';

import 'package:carePanda/pages/HRdashboardPage.dart';
import 'package:carePanda/pages/userboarding/user_boarding.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/pages/HomePage.dart';
import 'package:carePanda/pages/DashboardPage.dart';
import 'package:carePanda/pages/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:carePanda/ServiceLocator.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
          if (_isLoggedIn)
            BottomNavigationBarItem(
                icon: Icon(Icons.assessment), label: 'Statistics'),
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
