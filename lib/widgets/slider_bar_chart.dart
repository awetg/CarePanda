import 'package:carePanda/model/bar_chart_model.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carePanda/extensions.dart';

class SliderBarChart extends StatelessWidget {
  final List<SurveyResponse> data;
  const SliderBarChart({this.data});

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
            final String _graphTitle = question?.question ?? "Not found";

            final count = data.groupBy((d) => d.value);

            final series =
                List.generate(question.rangeMax.toInt(), (i) => (i + 1))
                    .map((e) => SliderBarChartModel(
                        x: e, y: count[e.toDouble().toString()]?.length ?? 0))
                    .toList();

            // convert list of survey response to a list series
            final List<charts.Series<SliderBarChartModel, String>>
                _chartSeries = [
              charts.Series(
                  id: "value",
                  data: series,
                  // areaColorFn: (_, __) => charts.Color.fromHex(code: "#e3f2fd"),
                  domainFn: (SliderBarChartModel res, _) => res.x.toString(),
                  measureFn: (SliderBarChartModel res, _) => res.y,
                  labelAccessorFn: (SliderBarChartModel res, _) =>
                      "${res.y}(${((res.y / data.length) * 100).toStringAsFixed(0)} %)",
                  colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault)
            ];

            return Container(
              height: 310,
              padding: EdgeInsets.only(left: 4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6),

                  // Title of the chart
                  Text(
                    _graphTitle,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "${data.length} responses",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 16),

                  Expanded(
                    // Chart
                    child: new charts.BarChart(
                      _chartSeries,
                      animate: true,
                      barRendererDecorator:
                          new charts.BarLabelDecorator<String>(
                        outsideLabelStyleSpec: new charts.TextStyleSpec(
                            color: charts.MaterialPalette.gray.shadeDefault),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault),
                          lineStyle: charts.LineStyleSpec(
                              thickness: 0,
                              color: charts.MaterialPalette.gray.shadeDefault),
                        ),
                      ),
                      domainAxis: charts.AxisSpec<String>(
                        renderSpec: charts.GridlineRendererSpec(
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
            // show error page if stream of list of question is null or empty
            return Container();
          }
        });
  }
}
