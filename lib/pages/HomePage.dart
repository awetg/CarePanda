import 'package:carePanda/widgets/CardWidget.dart';
import 'package:carePanda/widgets/OtherServicesPopup.dart';
import 'package:carePanda/pages/survey/survey_flow.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/widgets/Countdown.dart';
import 'dart:developer';
import 'package:carePanda/widgets/MsgForHRPopup.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/widgets/UserDataPopup.dart';

var _storageService = locator<LocalStorageService>();

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

// Base widget for homepage. Includes base layout and icon
class _HomePageState extends State<HomePage> {
  var _firstStartUp;
  var _userBoarding;

  @override
  void initState() {
    super.initState();
    // Gets boolean value wheter the app is started for the first time or not
    var _storageService = locator<LocalStorageService>();
    _firstStartUp = _storageService.firstTimeStartUp ?? true;
    _userBoarding = _storageService.showBoarding ?? true;
    log("first start up " + _firstStartUp.toString());
    if (_firstStartUp && !_userBoarding && _userBoarding != null) {
      openStartUpPopUp();
    }
  }

// If application is started for the first time, opens up a popup
  openStartUpPopUp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return UserDataPopup();
          });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Home',
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10),
              // Changes logo depending on theme
              if (!_storageService.darkTheme)
                Image.asset(
                  'assets/images/caregarooLogo_v2.png',
                  height: 200,
                  width: 400,
                ),
              if (_storageService.darkTheme)
                Image.asset(
                  'assets/images/caregaroologo_v2_light.png',
                  height: 200,
                  width: 400,
                ),

              AllCards(),
            ],
          ),
        ),
      ),
    );
  }
}

// Includes layout for all home screen cards (Questionnaire card, Countdown card and HR contacting card) and a load icon

class AllCards extends StatefulWidget {
  @override
  _AllCards createState() => _AllCards();
}

class _AllCards extends State<AllCards> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    return true;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
      future: checkHasQuestionnaire,
      builder: (context, snapshot) {
        // Shows questionnaire/countdown card and HR card when receiving boolean value from shared preference
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 20),

              // Shows questionnaire card if shared preference boolean value is true
              if (snapshot.data)
                SizedBox(
                  width: double.infinity,
                  child: CardWidget(
                    widget: Questionnaire(
                      countdownWidget:
                          WeekCountdown(questionnaireStatusChanged: () {
                        setState(() {});
                      }),
                    ),
                  ),
                ),

              // Shows countdown card if shared preference boolean value is false
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
              SizedBox(height: 8),

              // Shows big buttons for other services and sending msg for HR
              BigButtons()
            ],
          );

          // Shows loading indicator and HR card until receiving boolean value from shared preference
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 30),
                CircularProgressIndicator(),
                SizedBox(height: 30),

                // Shows big buttons for other services and sending msg for HR
                BigButtons()
              ],
            ),
          );
        }
      });
}

// Widget with countdown clock
class Timer extends StatelessWidget {
  Timer({this.timerWidget});
  final timerWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 15),
        Text('Time until next questionnaire',
            style: TextStyle(
                fontSize: 22.0, color: Theme.of(context).accentColor)),
        SizedBox(height: 10),
        timerWidget,
        SizedBox(height: 15),
      ],
    );
  }
}

// Widget card to display that user has a qeustionnaire
class Questionnaire extends StatelessWidget {
  Questionnaire({this.countdownWidget});
  final countdownWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 18),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You have a questionnaire',
                      style: TextStyle(
                          fontSize: 22.0,
                          color: Theme.of(context).accentColor)),
                ],
              ),
              SizedBox(height: 10),
              Text('Time to answer',
                  style: TextStyle(
                      fontSize: 16.0, color: Theme.of(context).accentColor)),
              countdownWidget,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        child: const Text('Answer now',
                            style: TextStyle(fontSize: 18)),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SurveyFlow()));
                          _storageService.hasQuestionnaire = false;
                          log("Questionnaire button pressed");
                        },
                      ),
                    ),
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

// Big buttons for other services and for sending a msg for HR
class BigButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Button for other services
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 12, right: 7),
                child: BigButton(
                    title: "Other services", dialog: OtherServicesPopup()))),

        // Button for sending a msg to HR
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(right: 12, left: 7),
              child: BigButton(
                  title: "Send message for HR", dialog: MsgForHRPopup())),
        ),
      ],
    );
  }
}

// Widget for big buttons (takes in a title and dialog)
class BigButton extends StatelessWidget {
  BigButton({this.title, this.dialog});
  final title;
  final dialog;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154,
      child: RaisedButton(
        child: Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
        color: Theme.of(context).cardColor,
        textColor: Theme.of(context).accentColor,
        onPressed: () {
          showDialog(
            barrierColor: _storageService.darkTheme
                ? Colors.black.withOpacity(0.4)
                : null,
            context: context,
            builder: (BuildContext context) {
              return dialog;
            },
          );
        },
      ),
    );
  }
}
