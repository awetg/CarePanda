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
    final remaining = nextDay.difference(_currentTime);

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;
    final millSec = remaining.inMilliseconds;

    var formattedRemaining;

    // Time formatting
    if (days != 0) {
      formattedRemaining = '$days : $hours : $minutes : $seconds';
    } else {
      formattedRemaining = '$hours : $minutes : $seconds';
    }

    // When timer hits 0, changes boolean value to show questionnaire card
    if (days <= 0 &&
        hours <= 0 &&
        minutes <= 0 &&
        seconds <= 0 &&
        millSec <= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _storageService.hasQuestionnaire = true;
        _storageService.lastAnsQuestionnaire = DateTime.now().toString();
        widget.questionnaireStatusChanged();
      });
    }

    return Text(formattedRemaining,
        style: TextStyle(fontSize: 36.0, color: Theme.of(context).accentColor));
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
