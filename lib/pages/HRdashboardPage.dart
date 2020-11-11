import 'package:carePanda/BarChart.dart';
import 'package:carePanda/widgets/TopButton.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/LineChart.dart';
import 'package:carePanda/ChartDataStructure.dart';
import 'package:carePanda/CardWidget.dart';
import 'dart:developer';

class HRdashboardPage extends StatefulWidget {
  @override
  _HRdashboardPageState createState() => _HRdashboardPageState();
}

class _HRdashboardPageState extends State<HRdashboardPage> {
  bool _showMentalHealth = true;
  bool _lineGraph = false;
  var _graphTitle = "Mental health";
  var _timePeriod = "Week";
  var _sortBy = "Building";
  var _lineGraphData;
  var _barGraphData;

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

  final buildingData = [
    new WellbeingDataByBuilding("Building 1", 7),
    new WellbeingDataByBuilding("Building 2", 6),
    new WellbeingDataByBuilding("Building 3", 5),
    new WellbeingDataByBuilding("Building 4", 4),
    new WellbeingDataByBuilding("Building 5", 10),
    new WellbeingDataByBuilding("Building 6", 2),
  ];

  final buildingDataPhysical = [
    new WellbeingDataByBuilding("Building 1", 6),
    new WellbeingDataByBuilding("Building 2", 5),
    new WellbeingDataByBuilding("Building 3", 5),
    new WellbeingDataByBuilding("Building 4", 8),
    new WellbeingDataByBuilding("Building 5", 9),
    new WellbeingDataByBuilding("Building 6", 2),
    new WellbeingDataByBuilding("Building 7", 5),
    new WellbeingDataByBuilding("Building 8", 3),
    new WellbeingDataByBuilding("Building 9", 2),
    new WellbeingDataByBuilding("Building 10", 7),
    new WellbeingDataByBuilding("Building 11", 4),
    new WellbeingDataByBuilding("Building 12", 2),
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
    _lineGraphData = weekData;
    _barGraphData = buildingData;
    super.initState();
  }

  // Shows physical health graph
  _showPhysicalGraph() {
    if (_showMentalHealth) {
      setState(() {
        _graphTitle = "Physical health";
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
        _graphTitle = "Mental health";
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

  // Changes chart / how to display data
  _sortByFunction(newValue) {
    setState(() {
      _sortBy = newValue;
      if (_sortBy != "Time") {
        _lineGraph = false;
      } else {
        _lineGraph = true;
      }
    });
    _dataToShow();
  }

  // Function to know what data to show
  _dataToShow() {
    if (_sortBy != "Time" && _showMentalHealth && !_lineGraph) {
      _barGraphData = buildingData;
    }

    if (_sortBy != "Time" && !_showMentalHealth && !_lineGraph) {
      _barGraphData = buildingDataPhysical;
    }

    if (_timePeriod == "Week" && _showMentalHealth) {
      _lineGraphData = weekData;
    }

    if (_timePeriod == "Week" && !_showMentalHealth) {
      _lineGraphData = weekPhysicalData;
    }

    if (_timePeriod == "Month" && _showMentalHealth) {
      _lineGraphData = monthPhysicalData;
    }

    if (_timePeriod == "Month" && !_showMentalHealth) {
      _lineGraphData = monthData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR statistics',
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                // Mental health button
                TopButton(
                  name: "Mental health",
                  boolState: !_showMentalHealth,
                  function: _showMentalGraph,
                ),

                // Physical health button
                TopButton(
                  name: "Physical health",
                  boolState: _showMentalHealth,
                  function: _showPhysicalGraph,
                ),
              ],
            ),
            SizedBox(height: 20),

            // Line graph which is built inside card widget
            if (_lineGraph)
              CardWidget(
                widget: LineChart(data: _lineGraphData, title: _graphTitle),
              ),

            // Bar graph is built inside card widget
            if (!_lineGraph)
              CardWidget(
                widget: BarChart(data: _barGraphData, title: _graphTitle),
              ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Time period
                Text(
                  "Data time period",
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
                SizedBox(width: 18),
              ],
            ),

            // Sort by time/building
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sort by",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 18),
                DropdownButton(
                  value: _sortBy,
                  underline: Container(
                    height: 1,
                  ),
                  items:
                      <String>["Building", 'Time', 'Age'].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _sortByFunction(newValue);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
