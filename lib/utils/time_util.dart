import 'package:carePanda/model/board_type.dart';
import 'package:carePanda/model/pair.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/pages/dashboard/day_board.dart';
import 'package:carePanda/pages/dashboard/month_board.dart';
import 'package:carePanda/pages/dashboard/week_board.dart';
import 'package:carePanda/pages/dashboard/year_board.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil {
  TimeUtil._privateConstructor();
  static final TimeUtil instance = TimeUtil._privateConstructor();

  // dashbaord time period filter (tab names)
  final List<String> personalTimePeriodTabs = ["Week", "Month", "Year"];
  final List<String> hrTimePeriodTabs = ["Day", "Week", "Month"];

  DateTime get startOfThisYear => new DateTime(DateTime.now().year, 1, 1);

  Pair<DateTime, DateTime> getStartAndEndOfWeek(DateTime date) {
    final start = _getDate(date.subtract(Duration(days: date.weekday - 1)));
    final end =
        _getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
    return Pair(start, end);
  }

  Pair<DateTime, DateTime> getStartAndEndOfMonth(DateTime date) {
    final startDay = (date.month < 12)
        ? new DateTime(date.year, date.month, 1)
        : new DateTime(date.year + 1, 1, 1);
    final lastDay = (date.month < 12)
        ? new DateTime(date.year, date.month + 1, 0)
        : new DateTime(date.year + 1, 1, 0);
    return Pair(startDay, lastDay);
  }

  Widget getTimePeriodWidget(String timePeriod, List<SurveyResponse> data,
      String boardTitle, BoardType boardType) {
    if (timePeriod == "Day") {
      return DayBoard(
        dayGraphData: _filterTimePeriodData(data, timePeriod),
        type: boardType,
        boardTitle: boardTitle,
      );
    } else if (timePeriod == "Week") {
      return WeekBoard(
        weekGraphData: _filterTimePeriodData(data, timePeriod),
        type: boardType,
        boardTitle: boardTitle,
      );
    } else if (timePeriod == "Month") {
      return MonthBoard(
        monthGraphData: _filterTimePeriodData(data, timePeriod),
        type: boardType,
        boardTitle: boardTitle,
      );
    } else {
      return YearBoard(
        yearGraphData: _filterTimePeriodData(data, timePeriod),
        type: boardType,
        boardTitle: boardTitle,
      );
    }
  }

  String getBoardTitle(String timePeriod) {
    final now = new DateTime.now();
    final lastMidnight = now.subtract(Duration(
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    ));
    final weekPair = TimeUtil.instance.getStartAndEndOfWeek(now);
    final _boardTitles = {
      "Day": DateFormat("EEEE, MMMM dd").format(lastMidnight),
      "Week": DateFormat("MMMM dd - ").format(weekPair.first) +
          DateFormat("d").format(weekPair.second),
      "Month": DateFormat("MMMM y").format(DateTime.now()),
      "Year": DateFormat("y").format(startOfThisYear)
    };
    return _boardTitles[timePeriod];
  }

  DateTime _getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<SurveyResponse> _filterTimePeriodData(
      List<SurveyResponse> data, String timePeriod) {
    if (timePeriod == "Day") {
      final now = new DateTime.now();
      final lastMidnight = now.subtract(Duration(
        hours: now.hour,
        minutes: now.minute,
        seconds: now.second,
        milliseconds: now.millisecond,
        microseconds: now.microsecond,
      ));
      return data.where((e) => lastMidnight.isBefore(e.time.toDate())).toList();
    } else if (timePeriod == "Week") {
      final weekPair = TimeUtil.instance.getStartAndEndOfMonth(DateTime.now());
      return data
          .where((e) => weekPair.first.isBefore(e.time.toDate()))
          .toList();
    } else if (timePeriod == "Month") {
      final monthPair = getStartAndEndOfMonth(DateTime.now());
      return data
          .where((e) => monthPair.first.isBefore(e.time.toDate()))
          .toList();
    } else {
      final startOfYear = startOfThisYear;
      return data.where((e) => startOfYear.isBefore(e.time.toDate())).toList();
    }
  }
}
