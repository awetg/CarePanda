import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carePanda/extensions.dart';

class BarChart extends StatelessWidget {
  final List<SurveyResponse> data;
  final String title;
  const BarChart({this.data, this.title});
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

    // sort data by time
    // data.sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));

    return StreamBuilder<List<QuestionItem>>(
        stream: locator<FirestoreService>().getSurveyQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            // find question corresponding to this group of responses or answers
            final QuestionItem question =
                snapshot.data.firstWhere((e) => e.id == title, orElse: null);
            // set the question as title of the graph
            final String _graphTitle = question?.question ?? "Not found";

            // convert list of survey response to a list series
            final List<charts.Series<SurveyResponse, String>> _chartSeries =
                data
                    .groupBy((d) => d.value)
                    .entries
                    .map((e) => new charts.Series<SurveyResponse, String>(
                        id: e.value[0].value,
                        data: e.value,
                        domainFn: (SurveyResponse res, _) =>
                            res.time.toDate().day.toString(),
                        measureFn: (SurveyResponse res, _) =>
                            question.options.indexOf(res.value) + 1))
                    .toList();

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
                    _graphTitle,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    // Chart
                    child: new charts.BarChart(
                      _chartSeries,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      // barGroupingType: charts.BarGroupingType.stacked,
                      // vertical: false,
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
          } else {
            // show error
            return Container();
          }
        });
  }
}
