import 'dart:developer';

import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carePanda/ServiceLocator.dart';

class WeekCountdown extends StatefulWidget {
  final VoidCallback questionnaireStatusChanged;
  WeekCountdown({this.questionnaireStatusChanged});

  @override
  State<StatefulWidget> createState() => _WeekCountdownState();
}

class _WeekCountdownState extends State<WeekCountdown> {
  Timer _timer;
  DateTime _currentTime;
  var _storageService;
  var _showLoading = false;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), onTimeChange);
    _storageService = locator<LocalStorageService>();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void onTimeChange(Timer _timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    var _lastQstRdy;
    _storageService = locator<LocalStorageService>();

    _currentTime = DateTime.now();

    // If last answered questionnaire is null (is null when launched first time)
    // Sets current time as last answered questionnaire
    if (_storageService.lastQuestionnaireRdy == null) {
      // If current time is over 3pm when application is opened first time, sets lastQuestionnaireRdy time to 2pm
      // This allows person to answer the questionnaire the first day user starts up the application
      if (_currentTime.hour > 15) {
        final _newlastQstRdyTime = new DateTime(_currentTime.year,
            _currentTime.month, _currentTime.day, 14, 0, 0, 0, 0);
        _storageService.lastQuestionnaireRdy = _newlastQstRdyTime.toString();
      } else {
        _storageService.lastQuestionnaireRdy = _currentTime.toString();
      }
    }

    _lastQstRdy = _storageService.lastQuestionnaireRdy;

    // Parses lastAnsQuest to DateTime since it's saved as string in shared preferences
    var parsedTime = DateTime.parse(_lastQstRdy);
    // Calculates till next time questionnaire is ready
    var nextDay = calculateNextQuestionnaire(parsedTime);
    // Calculates how much time is remaining to next questionnaire
    var remaining = nextDay.difference(_currentTime);

    // Calculates time difference between current time and since questionnaire is available
    var qstAvailableFor = _currentTime.difference(parsedTime);
    var calculatingRemaining = false;

    // If questionnaire is ready and questionnaire has been available for under 9 hours,
    // calculates how much time is left to answer the questionnaire
    if (qstAvailableFor.inHours <= 9 &&
        _storageService.hasQuestionnaire == true) {
      // Sets boolean calculating remaining to true, so that widget returns
      // how much time is reminaing to answer instead of how much time until next questionnaire
      calculatingRemaining = true;

      // Calculates how much time is left to answer
      var timeToAnswer = calculateTimeLefToAnswer(parsedTime);

      // Calculates remaining time
      final remainingToAnswer = timeToAnswer.difference(_currentTime);

      remaining = remainingToAnswer;
    }

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;
    final millSec = remaining.inMilliseconds;

    var formattedRemaining;

    // Extra 0 to show in timer if seconds are under 10
    var extra0;
    if (seconds < 10) {
      extra0 = "0";
    } else {
      extra0 = "";
    }

    // Time formatting
    if (days != 0) {
      formattedRemaining = '$days : $hours : $minutes : $extra0$seconds';
    } else {
      formattedRemaining = '$hours : $minutes : $extra0$seconds';
    }

    // When timer hits 0, changes boolean value to show questionnaire card
    if (days <= 0 &&
        hours <= 0 &&
        minutes <= 0 &&
        seconds <= 0 &&
        millSec <= 0) {
      // Shows loading circle instead of showing negative numbers even for split second
      _showLoading = true;
      // If timer of showing remaining time to answer questionnaire goes to 0, switches card
      // to show time until next questionnaire
      if (calculatingRemaining) {
        calculatingRemaining = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _storageService.hasQuestionnaire = false;
          widget.questionnaireStatusChanged();
          _showLoading = false;
        });
      } else {
        // If timer of showing how much time until next questionnaire goes to 0,
        // sets last time questionnaire is ready to current time
        // also sets hasQuestionnaire to true, to show correct card in home
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _storageService.hasQuestionnaire = true;
          _storageService.lastQuestionnaireRdy = DateTime.now().toString();
          widget.questionnaireStatusChanged();
          _showLoading = false;
        });
      }
    }

    // Returns timer, if it shows time remaining to answer, uses smaller font size
    return _showLoading
        ? CircularProgressIndicator()
        : Text(
            formattedRemaining,
            style: TextStyle(
                fontSize: calculatingRemaining ?? false ? 30 : 42.0,
                fontWeight: FontWeight.bold,
                color: _storageService.darkTheme
                    ? null
                    : Theme.of(context).accentColor),
          );
  }
}

// Calculates time until next questionnaire
DateTime calculateNextQuestionnaire(DateTime time) {
  var timeUntilNextDay3pm;

  var newTestTime =
      new DateTime(time.year, time.month, time.day, 15, 0, 0, 0, 0);

  // Calculates time until next questionnaire if it's not saturday
  if (time.weekday != 6 && time.weekday != 7) {
    // Calculates time until next questionnaire if it's not saturday and before 15:00
    if (time.isBefore(newTestTime)) {
      var timeUntilNext3pm = newTestTime.hour - time.hour;
      return DateTime(
          time.year, time.month, time.day, time.hour + timeUntilNext3pm);
    }

    // Calculates time until next questionnaire if it's not friday and after 15:00
    if (time.isAfter(newTestTime) && time.weekday != 5) {
      timeUntilNextDay3pm = time.weekday + 1 - time.weekday;
      return DateTime(
          time.year, time.month, time.day + timeUntilNextDay3pm, 15);
    }

    // Calculates time until next questionnaire if it's friday and after 15:00
    if (time.isAfter(newTestTime) && time.weekday == 5) {
      timeUntilNextDay3pm = 8 - time.weekday;
      return DateTime(
          time.year, time.month, time.day + timeUntilNextDay3pm, 15);
    }
  }
  // Calculates time until next questionnaire if it's saturday
  timeUntilNextDay3pm = 8 - time.weekday;
  return DateTime(time.year, time.month, time.day + timeUntilNextDay3pm, 15);
}

// Calculates how much time is left to answer the questionnaire
DateTime calculateTimeLefToAnswer(DateTime time) {
  var _answerTimeUntil =
      new DateTime(time.year, time.month, time.day, 23, 59, 59, 59, 0);

  return DateTime(
      time.year,
      time.month,
      time.day,
      _answerTimeUntil.hour,
      _answerTimeUntil.minute,
      _answerTimeUntil.second,
      _answerTimeUntil.millisecond);
}
