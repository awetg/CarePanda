import 'package:flutter/material.dart';
import 'package:carePanda/Countdown.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Home', style: TextStyle(fontSize: 36.0)),
          Text('Time until next questionnaire',
              style: TextStyle(fontSize: 20.0)),
          WeekCountdown()
        ],
      ),
    );
  }
}
