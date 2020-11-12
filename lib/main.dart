import 'package:carePanda/pages/userboarding/user_boarding.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/pages/HomePage.dart';
import 'package:carePanda/pages/DashboardPage.dart';
import 'package:carePanda/pages/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:carePanda/ServiceLocator.dart';

bool showBoarding;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initiliaze core firebase
  await Firebase.initializeApp();
  await setupLocator();
  var _storageService = locator<LocalStorageService>();
  showBoarding = _storageService.showBoarding ?? true;
  User user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    if (user.isAnonymous) {
      // show no anynoumous users menu items
    }
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print(e);
    }
  } else {
    try {
      FirebaseAuth.instance.signInAnonymously();
    } catch (e) {}
  }
  print("showBoarding = $showBoarding");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Care Panda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
  int _selectedPage = 0;
  final _pageOptions = [HomePage(), DashBoardPage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Color.fromRGBO(2, 125, 197, 90),
        selectedItemColor: Color(0xff027DC5),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), title: Text('Dashboard')),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text('Settings'))
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
