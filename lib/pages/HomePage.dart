import 'package:carePanda/pages/survey/survey_flow.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/Countdown.dart';
import 'dart:developer';
import 'package:carePanda/HRpopup.dart';
import 'package:carePanda/ServiceLocator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Home', style: TextStyle(color: Color(0xff027DC5))),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 10),
                Image.asset(
                  'assets/images/carepandaLogo.png',
                  height: 150,
                  width: 250,
                ),
                AllCards(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Includes all home screen cards (Questionnaire card, Countdown card and HR contacting card)
class AllCards extends StatefulWidget {
  @override
  _AllCards createState() => _AllCards();
}

class _AllCards extends State<AllCards> {
  @override
  void initState() {
    super.initState();
  }

  // Gets data wheter user has questionnare ready or not
  Future<bool> get checkHasQuestionnaire async {
    var _storageService = locator<LocalStorageService>();
    var _hasQuestionnaire = _storageService.hasQuestionnaire;

    // If the value is null, default it to false
    if (_hasQuestionnaire == null) {
      _storageService.hasQuestionnaire = false;
      _hasQuestionnaire = false;
    }

    return _hasQuestionnaire;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
      future: checkHasQuestionnaire,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          log("snapshot " + snapshot.data.toString());
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 30),
              if (snapshot.data)
                SizedBox(
                  width: double.infinity,
                  child: CardWidget(
                    widget: Questionnaire(),
                  ),
                ),
              if (!snapshot.data)
                SizedBox(
                  width: double.infinity,
                  child: CardWidget(
                    widget: Timer(
                      timerWidget: WeekCountdown(
                        questionnaireStatusChanged: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CardWidget(
                  widget: ContactHR(),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 30),
                CircularProgressIndicator(),
                SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: CardWidget(
                    widget: ContactHR(),
                  ),
                ),
              ],
            ),
          );
        }
      });
}

// Base widget for cards. Includes card shape and background color and it takes a widget as a variable
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

// Widget with countdown clock
class Timer extends StatelessWidget {
  Timer({this.timerWidget});
  final timerWidget;
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
        timerWidget,
        SizedBox(height: 15),
      ],
    );
  }
}

// Widget card to display that user has a qeustionnaire
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
                      Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => SurveyFlow()));
                      log("Questionnaire button pressed");
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

// Widget card for contacting HR
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
                      // Opens pop up to give a phone number
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return HRPopup();
                          });
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
