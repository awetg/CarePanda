import 'package:flutter/material.dart';
import 'package:carePanda/Countdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasQuestionnaire = false;

  @override
  void initState() {
    super.initState();
    _loadQuestionnaire();
  }

  _loadQuestionnaire() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasQuestionnaire = (prefs.getBool('hasQuestionnaire') ?? false);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Home', style: TextStyle(color: Color(0xff027DC5))),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              Image.asset(
                'assets/images/carepandaLogo.png',
                height: 150,
                width: 250,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_hasQuestionnaire)
                        SizedBox(
                          width: double.infinity,
                          child: CardWidget(
                            widget: Questionnaire(),
                          ),
                        ),
                      if (!_hasQuestionnaire)
                        SizedBox(
                          width: double.infinity,
                          child: CardWidget(
                            widget: Timer(),
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        child: CardWidget(
                          widget: ContactHR(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  CardWidget({this.widget});
  final widget;

  //final cardColor = Color(0xffD7E0EB);
  final cardColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: cardColor,
        child: widget,
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
            style: TextStyle(fontSize: 22.0, color: textColor)),
        SizedBox(height: 10),
        WeekCountdown(),
        SizedBox(height: 15),
      ],
    );
  }
}

class Questionnaire extends StatelessWidget {
  final textColor = Color(0xff027DC5);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You have a questionnaire',
                style: TextStyle(fontSize: 22.0, color: textColor)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              child: const Text('Answer now', style: TextStyle(fontSize: 18)),
              color: textColor,
              textColor: Colors.white,
              splashColor: Color(0xffD7E0EB),
              onPressed: () {
                log("button pressed");
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}

class ContactHR extends StatelessWidget {
  final textColor = Color(0xff027DC5);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Need help?',
                style: TextStyle(fontSize: 22.0, color: textColor)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              child: const Text('Contact HR', style: TextStyle(fontSize: 18)),
              color: textColor,
              textColor: Colors.white,
              splashColor: Color(0xffD7E0EB),
              onPressed: () {
                log("button pressed");
              },
            ),
            SizedBox(width: 15),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
