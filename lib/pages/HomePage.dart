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
                      if (!_hasQuestionnaire)
                        SizedBox(
                          width: double.infinity,
                          child: CardWidget(
                            widget: Questionnaire(),
                          ),
                        ),
                      if (_hasQuestionnaire)
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
  final _blueColor = Color(0xff027DC5);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 18),
        Icon(Icons.assignment, size: 55, color: _blueColor),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('You have a questionnaire',
                      style: TextStyle(fontSize: 22.0, color: _blueColor)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Answer now',
                        style: TextStyle(fontSize: 18)),
                    color: _blueColor,
                    textColor: Colors.white,
                    splashColor: Color(0xffD7E0EB),
                    onPressed: () {
                      log("button pressed");
                    },
                  ),
                  SizedBox(width: 18),
                ],
              ),
              SizedBox(height: 18),
            ],
          ),
        )
      ],
    );
  }
}

class ContactHR extends StatelessWidget {
  final _blueColor = Color(0xff027DC5);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 18),
        Icon(Icons.help, size: 55, color: _blueColor),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Need professional help?',
                      style: TextStyle(fontSize: 22.0, color: _blueColor)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    child: const Text('Contact HR',
                        style: TextStyle(fontSize: 18)),
                    color: _blueColor,
                    textColor: Colors.white,
                    splashColor: Color(0xffD7E0EB),
                    onPressed: () {
                      log("button pressed");
                    },
                  ),
                  SizedBox(width: 18),
                ],
              ),
              SizedBox(height: 18),
            ],
          ),
        )
      ],
    );
  }
}
