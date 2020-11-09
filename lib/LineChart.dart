import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
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

  _axisColor() {
    var _storageService = locator<LocalStorageService>();
    if (_storageService.darkTheme) {
      return charts.MaterialPalette.white;
    } else {
      return charts.MaterialPalette.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Color for axis
    var axis = charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(color: _axisColor()),
        lineStyle: charts.LineStyleSpec(
            thickness: 0, color: charts.MaterialPalette.gray.shadeDefault),
      ),
    );

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
            child: new charts.TimeSeriesChart(
              _getWellbeingData(),
              animate: true,
              primaryMeasureAxis: axis,
              behaviors: [
                charts.LinePointHighlighter(
                  drawFollowLinesAcrossChart: true,
                  showHorizontalFollowLine:
                      charts.LinePointHighlighterFollowLineType.all,
                )
              ],
              domainAxis: charts.DateTimeAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(color: _axisColor()),
                  lineStyle: charts.LineStyleSpec(
                      thickness: 0,
                      color: charts.MaterialPalette.gray.shadeDefault),
                ),
                //tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
                tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                    format: 'dd-MM',
                    transitionFormat: 'dd-MM',
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
