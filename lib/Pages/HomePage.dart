import 'package:flutter/material.dart';
import 'package:carePanda/Countdown.dart';
import 'package:carePanda/globals.dart' as globals;

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(width: double.infinity, child: QuesttionaireCard()),
            ],
          ),
        ),
      ),
    );
  }
}

class QuesttionaireCard extends StatelessWidget {
  final cardColor = Color(0xffD7E0EB);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: cardColor,
        child: Column(
          children: [if (!globals.hasQuestionnaire) Timer()],
        ),
      ),
    );
  }
}

class Timer extends StatelessWidget {
  final textColor = Color(0xff027DC5);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 15),
        Text('Time until next questionnaire',
            style: TextStyle(fontSize: 23.0, color: textColor)),
        SizedBox(height: 10),
        WeekCountdown(),
        SizedBox(height: 15),
      ],
    );
  }
}
