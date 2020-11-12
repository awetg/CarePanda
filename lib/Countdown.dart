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
    var _lastAnsQuest;
    _storageService = locator<LocalStorageService>();

    _currentTime = DateTime.now();

    if (_storageService.lastAnsQuestionnaire == null) {
      _storageService.lastAnsQuestionnaire = _currentTime.toString();
    }

    _lastAnsQuest = _storageService.lastAnsQuestionnaire;

    var parsedTime = DateTime.parse(_lastAnsQuest);
    var nextDay = calculateNextQuestionnaire(parsedTime);
    var remaining = nextDay.difference(_currentTime);

    var timeLeftToAnswer = _currentTime.difference(parsedTime);
    var calculatingRemaining = false;

    // If questionnaire is ready, calculates how much time is left to answer the questionnaire
    if (timeLeftToAnswer.inHours <= 9 &&
        _storageService.hasQuestionnaire == true) {
      calculatingRemaining = true;
      var timeToAnswer = calculateTimeLefToAnswer(parsedTime);
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
      // If timer of remaining time of answering questionnaire goes to 0, switches card
      if (calculatingRemaining) {
        calculatingRemaining = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _storageService.hasQuestionnaire = false;
          widget.questionnaireStatusChanged();
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _storageService.hasQuestionnaire = true;
          _storageService.lastAnsQuestionnaire = DateTime.now().toString();
          widget.questionnaireStatusChanged();
        });
      }
    }

    // Returns timer, if it shows time remaining to answer, uses smaller font size
    return Text(formattedRemaining,
        style: TextStyle(
            fontSize: calculatingRemaining ?? false ? 30 : 42.0,
            fontWeight: FontWeight.bold,
            color: _storageService.darkTheme
                ? null
                : Theme.of(context).accentColor));
  }
}

// Calculates time until next questionnaire
DateTime calculateNextQuestionnaire(DateTime time) {
  var timeUntilNextDay3pm;

  var newTestTime =
      new DateTime(time.year, time.month, time.day, 15, 0, 0, 0, 0);

  // Calculates time until next questionnaire if it's not saturday
  if (time.weekday != 6) {
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

DateTime calculateTimeLefToAnswer(DateTime time) {
  var test2 = new DateTime(time.year, time.month, time.day, 23, 59, 59, 59, 0);

  return DateTime(time.year, time.month, time.day, test2.hour, test2.minute,
      test2.second, test2.millisecond);
}
