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
    final textColor = Color(0xff027DC5);
    final newTime = _currentTime.subtract(new Duration(hours: 15));
    //final nextWednesday = calculateNextWednesday(newTime);
    //final remaining = nextWednesday.difference(newTime);
    final nextDay = calculateNextDay(newTime);
    final remaining = nextDay.difference(newTime);

    final days = remaining.inDays;
    final hours = remaining.inHours - remaining.inDays * 24;
    final minutes = remaining.inMinutes - remaining.inHours * 60;
    final seconds = remaining.inSeconds - remaining.inMinutes * 60;

    var formattedRemaining;

    if (days != 0) {
      formattedRemaining = '$days : $hours : $minutes : $seconds';
    } else {
      formattedRemaining = '$hours : $minutes : $seconds';
    }

    if (days == 0 && hours == 0 && minutes == 0 && seconds == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _storageService.hasQuestionnaire = true;
        widget.questionnaireStatusChanged();
      });
    }

    return Text(formattedRemaining,
        style: TextStyle(fontSize: 36.0, color: textColor));
  }
}

/*
DateTime calculateNextWednesday(DateTime time) {
  var daysUntilNextWeek;
  if (time.weekday < 3) {
    daysUntilNextWeek = 3 - time.weekday;
  }
  if (time.weekday >= 3) {
    daysUntilNextWeek = 10 - time.weekday;
  }
  return DateTime(time.year, time.month, time.day + daysUntilNextWeek);
}*/

DateTime calculateNextDay(DateTime time) {
  var timeUntilNextDay;
  if (time.weekday != 6 && time.weekday != 5) {
    timeUntilNextDay = time.weekday + 1 - time.weekday;
  } else {
    timeUntilNextDay = 8 - time.weekday;
  }
  return DateTime(time.year, time.month, time.day + timeUntilNextDay);
}
