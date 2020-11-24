import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/graph_time_format.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common show DateTimeFactory;
import 'package:intl/intl.dart';

/* 
  NOTE: 
    -Changed LineChart widget to Stateless widget since it doesn't maintain state
    - TODO: change LineChart widget arguments or handle gracefully when value of survey response object is not number, 
      it only support passing list of survery response where type is RangeSelection at the moment
    - TODO: Replace list of question stream in build function, it used to get all questions and get a single question by id
*/

class TimeSeriesChart extends StatelessWidget {
  final List<SurveyResponse> data;
  final GraphTimeFormat graphTimeFormat;
  const TimeSeriesChart({this.data, this.graphTimeFormat});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuestionItem>>(
        stream: locator<FirestoreService>().getSurveyQuestions(),
        builder: (context, snapshot) {
          // set question as title of the graph
          if (snapshot.hasData && snapshot.data.length > 0) {
            // find question corresponding to this group of responses or answers
            final QuestionItem question = snapshot.data
                .firstWhere((e) => e.id == data.first.questionId, orElse: null);
            // set the question as title of the graph
            final String _graphTitle =
                question?.question ?? getTranslated(context, "graph_notFound");

            data.sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));

            // convert list of survey response to a list series
            final List<charts.Series<SurveyResponse, DateTime>> _chartSeries = [
              charts.Series(
                  id: "value",
                  data: data,
                  areaColorFn: (_, __) => charts.Color.fromHex(code: "#e3f2fd"),
                  domainFn: (SurveyResponse res, _) => res.time.toDate(),
                  measureFn: (SurveyResponse res, _) => double.parse(res.value),
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault)
            ];

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
                    child: new charts.TimeSeriesChart(
                      _chartSeries,
                      animate: true,
                      // defaultInteractions: false,
                      // defaultRenderer: new charts.BarRendererConfig<DateTime>(
                      //     strokeWidthPx: 20.0),
                      // defaultRenderer: charts.LineRendererConfig(
                      //     includeArea: true, stacked: true),
                      defaultRenderer: charts.LineRendererConfig(
                        includePoints: true,
                      ),
                      dateTimeFactory: LocalizedTimeFactory(
                          locator<LocalStorageService>().language),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault),
                          lineStyle: charts.LineStyleSpec(
                              thickness: 0,
                              color: charts.MaterialPalette.gray.shadeDefault),
                        ),
                      ),
                      behaviors: [
                        charts.SlidingViewport(),
                        charts.PanAndZoomBehavior(),
                      ],
                      domainAxis: charts.DateTimeAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelRotation:
                              (locator<LocalStorageService>().language ??
                                              "en") ==
                                          "fi" &&
                                      graphTimeFormat.timeFormat == "MMM"
                                  ? 50
                                  : 0,
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault),
                          lineStyle: charts.LineStyleSpec(
                              thickness: 0,
                              color: charts.MaterialPalette.gray.shadeDefault),
                        ),
                        tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                            graphTimeFormat.tickSpec),
                        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                            month: charts.TimeFormatterSpec(
                              format: graphTimeFormat.timeFormat,
                              transitionFormat: graphTimeFormat.timeFormat,
                            ),
                            year: charts.TimeFormatterSpec(
                              format: graphTimeFormat.timeFormat,
                              transitionFormat: graphTimeFormat.timeFormat,
                            ),
                            day: charts.TimeFormatterSpec(
                              format: graphTimeFormat.timeFormat,
                              transitionFormat: graphTimeFormat.timeFormat,
                            ),
                            minute: charts.TimeFormatterSpec(
                              format: graphTimeFormat.timeFormat,
                              transitionFormat: graphTimeFormat.timeFormat,
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            );
          } else {
            // show error page if stream of list of question is null or empty
            return Container();
          }
        });
  }
}

class LocalizedTimeFactory implements common.DateTimeFactory {
  final languageCode;
  const LocalizedTimeFactory(this.languageCode);

  DateFormat createDateFormat(String pattern) {
    return DateFormat(pattern, languageCode);
  }

  @override
  DateTime createDateTime(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    throw UnimplementedError();
  }

  @override
  DateTime createDateTimeFromMilliSecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    throw UnimplementedError();
  }
}
