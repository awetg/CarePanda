import 'package:charts_flutter/flutter.dart' as charts;

class GraphTimeFormat {
  final String timeFormat;
  final List<charts.TickSpec<DateTime>> tickSpec;
  const GraphTimeFormat({this.timeFormat, this.tickSpec});
}
