import 'package:carePanda/model/bar_chart_model.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carePanda/extensions.dart';

class BarChart extends StatelessWidget {
  final List<SurveyResponse> data;
  const BarChart({this.data});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuestionItem>>(
        stream: locator<FirestoreService>().getSurveyQuestions(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.length > 0) {
            // find question corresponding to this group of responses or answers
            final QuestionItem question = snapshot.data
                .firstWhere((e) => e.id == data.first.questionId, orElse: null);
            // set the question as title of the graph
            final String _graphTitle = question?.question ?? "Not found";

            // sort
            data.sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));

            var dayGroup = data.groupBy(
                (d) => d.time.toDate().toIso8601String().split('T').first);

            var series = dayGroup.values
                .map((e) => e
                    .groupBy((s) => s.value)
                    .entries
                    .map((e) => BarChartModel(
                        option: e.value.first.value,
                        dateTime: e.value.first.time.toDate(),
                        value: e.value.length))
                    .toList())
                .toList()
                .expand((e) => e)
                .toList();

            // var s = dayGroup.map((key, value) => MapEntry(
            //     key,
            //     BarChartModel(
            //         option: value.first.value,
            //         dateTime: value.first.time.toDate(),
            //         value: value.length)));

            // var barmodels = dayGroup.entries
            //     .map((e) => e.value
            //         .groupBy((v) => v.value)
            //         .entries
            //         .map((e) => MapEntry(
            //             e.key,
            //             BarChartModel(
            //                 option: e.value.first.value,
            //                 dateTime: e.value.first.time.toDate(),
            //                 value: e.value.length)))
            //         .toList())
            //     .toList();

            // convert list of survey response to a list series
            final List<charts.Series<BarChartModel, String>> _chartSeries =
                series
                    .groupBy((d) => d.option)
                    .entries
                    .map((e) => new charts.Series<BarChartModel, String>(
                          id: e.key,
                          data: e.value,
                          domainFn: (BarChartModel res, _) =>
                              res.dateTime.day.toString(),
                          measureFn: (BarChartModel res, _) => res.value,
                          // labelAccessorFn: (SurveyResponse res, _) =>
                          //     '${res.value}'
                        ))
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    // Chart
                    child: new charts.BarChart(
                      _chartSeries,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: [new charts.SeriesLegend()],
                      // defaultInteractions: false,
                      // vertical: false,
                      // Color for axis
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault),
                          lineStyle: charts.LineStyleSpec(
                              thickness: 0,
                              color: charts.MaterialPalette.gray.shadeDefault),
                        ),
                      ),
                      domainAxis: charts.OrdinalAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          // labelRotation: 60,
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault),
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
