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

  @override
  void initState() {
    // When page is opened, defaults time period to week
    _graphData = weekData;
    super.initState();
  }

  // Shows physical health graph
  _showPhysicalGraph() {
    setState(() {
      _graphTitle = "Personal physical health";
      _showMentalHealth = false;
    });
    _dataToShow();
  }

  // Shows mental health graph
  _showMentalGraph() {
    setState(() {
      _graphTitle = "Personal mental health";
      _showMentalHealth = true;
    });
    _dataToShow();
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
    if (_timePeriod == "Month") {
      _graphData = monthData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Dashboard',
              style: TextStyle(color: Color(0xff027DC5))),
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
                    color: _showMentalHealth ? Color(0xffF8F8F6) : _blueColor,
                    textColor: _showMentalHealth ? _blueColor : Colors.white,
                    splashColor: Color(0xffD7E0EB),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: _blueColor, width: 2),
                    ),
                    onPressed: () {
                      _showMentalGraph();
                    },
                  ),
                  SizedBox(width: 12),

                  // Physical health button
                  RaisedButton(
                    child: const Text('Physical health',
                        style: TextStyle(fontSize: 18)),
                    color: _showMentalHealth ? _blueColor : Color(0xffF8F8F6),
                    textColor: _showMentalHealth ? Colors.white : _blueColor,
                    splashColor: Color(0xffD7E0EB),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: _blueColor, width: 2),
                    ),
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

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Personal data time period",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(width: 18),
                DropdownButton(
                  value: _timePeriod,
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  items: <String>["Week", 'Month', 'All'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
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
      ),
    );
  }
}
