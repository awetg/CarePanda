import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/* 
  NOTE: 
    -Changed LineChart widget to Stateless widget since it doesn't maintain state
    - Changed axis color to `charts.MaterialPalette.blue.shadeDefault` since the color of line is changed to white or black only
      to have previous effect set it to `locator<LocalStorageService>().darkTheme ? charts.MaterialPalette.white : charts.MaterialPalette.black`
    - TODO: change LineChart widget arguments or handle gracefully when value of survey response object is not number, 
      it only support passing list of survery response where type is RangeSelection at the moment
    - TODO: Replace list of question stream in build function, it used to get all questions and get a single question by id
*/

class LineChart extends StatelessWidget {
  final List<SurveyResponse> data;
  final String title;
  const LineChart({this.data, this.title});

  @override
  Widget build(BuildContext context) {
    // Color for axis
    final charts.NumericAxisSpec axis = charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.blue.shadeDefault),
        lineStyle: charts.LineStyleSpec(
            thickness: 0, color: charts.MaterialPalette.gray.shadeDefault),
      ),
    );

    return StreamBuilder<List<QuestionItem>>(
        stream: locator<FirestoreService>().getSurveyQuestions(),
        builder: (context, snapshot) {
          // set question as title of the graph
          if (snapshot.hasData && snapshot.data.length > 0) {
            // find question corresponding to this group of responses or answers
            final QuestionItem question =
                snapshot.data.firstWhere((e) => e.id == title, orElse: null);
            // set the question as title of the graph
            final String _graphTitle = question?.question ?? "Not found";

            // sort
            data.sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));

            // convert list of survey response to a list series
            final List<charts.Series<SurveyResponse, DateTime>> _chartSeries = [
              charts.Series(
                  id: "value",
                  data: data,
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(height: 8),

                  Expanded(
                    // Chart
                    child: new charts.TimeSeriesChart(
                      _chartSeries,
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
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.blue.shadeDefault),
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
          } else {
            // show error page if stream of list of question is null or empty
            return Container();
          }
        });
  }
}
