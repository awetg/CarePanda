import 'package:flutter/material.dart';
import 'package:carePanda/ChartDataStructure.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class LineChart extends StatefulWidget {
  final data;
  final title;
  LineChart({this.data, this.title});

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  // Sets data for the chart
  _getWellbeingData() {
    List<charts.Series<WellbeingData, DateTime>> wellbeing = [
      charts.Series(
          id: "Wellbeing",
          data: widget.data,
          domainFn: (WellbeingData wellbeing, _) => wellbeing.date,
          measureFn: (WellbeingData wellbeing, _) => wellbeing.wellbeing,
          colorFn: (WellbeingData wellbeing, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];
    return wellbeing;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
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

          SizedBox(height: 6),
          Expanded(
            // Chart
            child: new charts.TimeSeriesChart(
              _getWellbeingData(),
              animate: true,
              domainAxis: charts.DateTimeAxisSpec(
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                    format: 'dd-MM',
                    transitionFormat: 'dd-MM',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
