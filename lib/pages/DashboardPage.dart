import 'package:flutter/material.dart';
import 'package:carePanda/LineChart.dart';
import 'package:carePanda/ChartDataStructure.dart';
import 'package:carePanda/CardWidget.dart';
import 'dart:developer';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  final _blueColor = Color(0xff027DC5);
  final _lightBlueColor = Color(0xffA0C3E2);
  bool _showMentalHealth = true;
  var _graphTitle = "Personal mental health";
  var _timePeriod = "Week";
  var _graphData;

  // Fake data
  final weekData = [
    new WellbeingData(new DateTime(2020, 9, 20), 5),
    new WellbeingData(new DateTime(2020, 9, 19), 5),
    new WellbeingData(new DateTime(2020, 9, 18), 7),
    new WellbeingData(new DateTime(2020, 9, 17), 6),
    new WellbeingData(new DateTime(2020, 9, 16), 3),
    new WellbeingData(new DateTime(2020, 9, 15), 10),
    new WellbeingData(new DateTime(2020, 9, 14), 8),
  ];

  final weekPhysicalData = [
    new WellbeingData(new DateTime(2020, 9, 20), 10),
    new WellbeingData(new DateTime(2020, 9, 19), 9),
    new WellbeingData(new DateTime(2020, 9, 18), 9),
    new WellbeingData(new DateTime(2020, 9, 17), 8),
    new WellbeingData(new DateTime(2020, 9, 16), 8),
    new WellbeingData(new DateTime(2020, 9, 15), 9),
    new WellbeingData(new DateTime(2020, 9, 14), 6),
  ];

  final monthData = [
    new WellbeingData(new DateTime(2020, 8, 30), 5),
    new WellbeingData(new DateTime(2020, 8, 29), 5),
    new WellbeingData(new DateTime(2020, 8, 28), 7),
    new WellbeingData(new DateTime(2020, 8, 27), 6),
    new WellbeingData(new DateTime(2020, 8, 26), 4),
    new WellbeingData(new DateTime(2020, 8, 25), 9),
    new WellbeingData(new DateTime(2020, 8, 24), 10),
    new WellbeingData(new DateTime(2020, 8, 23), 9),
    new WellbeingData(new DateTime(2020, 8, 22), 9),
    new WellbeingData(new DateTime(2020, 8, 21), 6),
    new WellbeingData(new DateTime(2020, 8, 20), 2),
    new WellbeingData(new DateTime(2020, 8, 19), 6),
    new WellbeingData(new DateTime(2020, 8, 18), 7),
    new WellbeingData(new DateTime(2020, 8, 17), 5),
    new WellbeingData(new DateTime(2020, 8, 16), 4),
    new WellbeingData(new DateTime(2020, 8, 15), 5),
    new WellbeingData(new DateTime(2020, 8, 14), 8),
    new WellbeingData(new DateTime(2020, 8, 13), 6),
    new WellbeingData(new DateTime(2020, 8, 12), 5),
    new WellbeingData(new DateTime(2020, 8, 11), 5),
    new WellbeingData(new DateTime(2020, 8, 10), 7),
    new WellbeingData(new DateTime(2020, 8, 9), 1),
    new WellbeingData(new DateTime(2020, 8, 8), 2),
    new WellbeingData(new DateTime(2020, 8, 7), 5),
    new WellbeingData(new DateTime(2020, 8, 6), 4),
    new WellbeingData(new DateTime(2020, 8, 5), 3),
    new WellbeingData(new DateTime(2020, 8, 4), 6),
    new WellbeingData(new DateTime(2020, 8, 3), 3),
    new WellbeingData(new DateTime(2020, 8, 2), 10),
    new WellbeingData(new DateTime(2020, 8, 1), 8),
  ];

  final monthPhysicalData = [
    new WellbeingData(new DateTime(2020, 8, 30), 7),
    new WellbeingData(new DateTime(2020, 8, 29), 7),
    new WellbeingData(new DateTime(2020, 8, 28), 7),
    new WellbeingData(new DateTime(2020, 8, 27), 4),
    new WellbeingData(new DateTime(2020, 8, 26), 2),
    new WellbeingData(new DateTime(2020, 8, 25), 3),
    new WellbeingData(new DateTime(2020, 8, 24), 5),
    new WellbeingData(new DateTime(2020, 8, 23), 7),
    new WellbeingData(new DateTime(2020, 8, 22), 9),
    new WellbeingData(new DateTime(2020, 8, 21), 10),
    new WellbeingData(new DateTime(2020, 8, 20), 10),
    new WellbeingData(new DateTime(2020, 8, 19), 10),
    new WellbeingData(new DateTime(2020, 8, 18), 7),
    new WellbeingData(new DateTime(2020, 8, 17), 5),
    new WellbeingData(new DateTime(2020, 8, 16), 5),
    new WellbeingData(new DateTime(2020, 8, 15), 4),
    new WellbeingData(new DateTime(2020, 8, 14), 6),
    new WellbeingData(new DateTime(2020, 8, 13), 4),
    new WellbeingData(new DateTime(2020, 8, 12), 3),
    new WellbeingData(new DateTime(2020, 8, 11), 2),
    new WellbeingData(new DateTime(2020, 8, 10), 3),
    new WellbeingData(new DateTime(2020, 8, 9), 3),
    new WellbeingData(new DateTime(2020, 8, 8), 6),
    new WellbeingData(new DateTime(2020, 8, 7), 5),
    new WellbeingData(new DateTime(2020, 8, 6), 7),
    new WellbeingData(new DateTime(2020, 8, 5), 8),
    new WellbeingData(new DateTime(2020, 8, 4), 8),
    new WellbeingData(new DateTime(2020, 8, 3), 9),
    new WellbeingData(new DateTime(2020, 8, 2), 10),
    new WellbeingData(new DateTime(2020, 8, 1), 8),
  ];

  @override
  void initState() {
    // When page is opened, defaults time period to week
    _graphData = weekData;
    super.initState();
  }

  // Shows physical health graph
  _showPhysicalGraph() {
    if (_showMentalHealth) {
      setState(() {
        _graphTitle = "Personal physical health";
        _showMentalHealth = false;
      });
      _dataToShow();
    } else {
      return null;
    }
  }

  // Shows mental health graph
  _showMentalGraph() {
    if (!_showMentalHealth) {
      setState(() {
        _graphTitle = "Personal mental health";
        _showMentalHealth = true;
      });
      _dataToShow();
    } else {
      return null;
    }
  }

  // Changes the time period of personal health graph
  _newTimePeriod(newValue) {
    setState(() {
      _timePeriod = newValue;
    });
    _dataToShow();
  }

  // Function to know what data to show
  _dataToShow() {
    if (_timePeriod == "Week" && _showMentalHealth) {
      _graphData = weekData;
    }
    if (_timePeriod == "Week" && !_showMentalHealth) {
      _graphData = weekPhysicalData;
    }
    if (_timePeriod == "Month" && _showMentalHealth) {
      _graphData = monthPhysicalData;
    }
    if (_timePeriod == "Month" && !_showMentalHealth) {
      _graphData = monthData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mental health button
                RaisedButton(
                  child: const Text('Mental health',
                      style: TextStyle(fontSize: 18)),
                  color: _showMentalHealth
                      ? Theme.of(context).disabledColor
                      : Theme.of(context).buttonColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _showMentalGraph();
                  },
                ),
                SizedBox(width: 12),

                // Physical health button
                RaisedButton(
                  child: const Text('Physical health',
                      style: TextStyle(fontSize: 18)),
                  color: _showMentalHealth
                      ? Theme.of(context).buttonColor
                      : Theme.of(context).disabledColor,
                  textColor: Colors.white,
                  onPressed: () {
                    _showPhysicalGraph();
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Graph which is built inside card widget
            CardWidget(
              widget: LineChart(data: _graphData, title: _graphTitle),
            ),
            SizedBox(height: 10),

            // Time period
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Personal data time period",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 18),
              DropdownButton(
                value: _timePeriod,
                underline: Container(
                  height: 1,
                ),
                items: <String>["Week", 'Month', 'All'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _newTimePeriod(newValue);
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
