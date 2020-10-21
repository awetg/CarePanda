import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:carePanda/globals.dart' as globals;

class WeekCountdown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeekCountdownState();
}

class _WeekCountdownState extends State<WeekCountdown> {
  Timer timer;
  DateTime currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    timer = Timer.periodic(Duration(seconds: 1), onTimeChange);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void onTimeChange(Timer timer) {
    setState(() {
      currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Color(0xff027DC5);
    final newTime = currentTime.subtract(new Duration(hours: 15));
    final nextWednesday = calculateNextWednesday(newTime);
    final remaining = nextWednesday.difference(newTime);

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
      globals.hasQuestionnaire = true;
    }

    return Text(formattedRemaining,
        style: TextStyle(fontSize: 36.0, color: textColor));
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
