import 'package:flutter/material.dart';
import 'dart:async';

class WeekCountdown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeekCountdownState();
}

class _WeekCountdownState extends State<WeekCountdown> {
  Timer _timer;
  DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), _onTimeChange);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nextWednesday = calculateNextWednesday(_currentTime);
    final remaining = nextWednesday.difference(_currentTime);

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

    return Text(formattedRemaining, style: TextStyle(fontSize: 36.0));
  }
}

DateTime calculateNextWednesday(DateTime time) {
  var daysUntilNextWeek;
  if (time.weekday < 3) {
    daysUntilNextWeek = 3 - time.weekday;
  }
  if (time.weekday >= 3) {
    daysUntilNextWeek = 10 - time.weekday;
  }
  return DateTime(time.year, time.month, time.day + daysUntilNextWeek);
}
