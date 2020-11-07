import 'package:flutter/material.dart';
import 'package:carePanda/ChartDataStructure.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChart extends StatefulWidget {
  final data;
  final title;
  BarChart({this.data, this.title});

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  _getWellbeingData() {
    List<charts.Series<WellbeingDataByBuilding, String>> wellbeing = [
      charts.Series(
          id: "Wellbeing",
          data: widget.data,
          domainFn: (WellbeingDataByBuilding wellbeing, _) =>
              wellbeing.building,
          measureFn: (WellbeingDataByBuilding wellbeing, _) =>
              wellbeing.wellbeing,
          colorFn: (WellbeingDataByBuilding wellbeing, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return wellbeing;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      padding: EdgeInsets.only(left: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 6),

          // Title of the chart
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8),

          Expanded(
            // Chart
            child: new charts.BarChart(
              _getWellbeingData(),
              animate: true,
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(labelRotation: 60),
              ),
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
