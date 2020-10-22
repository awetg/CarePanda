import 'package:carePanda/pages/user_boarding.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/pages/HomePage.dart';
import 'package:carePanda/pages/DashboardPage.dart';
import 'package:carePanda/pages/SettingsPage.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool showBoarding;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  showBoarding = await prefs.getBool("showBoarding") ?? true;
  await prefs.setBool("showBoarding", false);
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
      appBar: AppBar(
        title: Text('Care Panda'),
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
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
