import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
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
            child: new charts.BarChart(
              _getWellbeingData(),
              animate: true,
              primaryMeasureAxis: axis,
              domainAxis: charts.OrdinalAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelRotation: 60,
                  labelStyle: charts.TextStyleSpec(color: _axisColor()),
                  lineStyle: charts.LineStyleSpec(
                      thickness: 0,
                      color: charts.MaterialPalette.gray.shadeDefault),
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
