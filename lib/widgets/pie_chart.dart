import 'package:carePanda/model/pie_chart_model.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:carePanda/extensions.dart';

class PieChart extends StatelessWidget {
  final List<SurveyResponse> data;
  const PieChart({this.data});

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

            final group = data.groupBy((d) => d.value);
            final series = List.generate(question.options.length, (i) => i)
                .map((e) => PieChartModel(
                    optionCount: group[question.options[e]].length,
                    option: question.options[e]))
                .toList();

            // convert list of survey response to a list series
            final List<charts.Series<PieChartModel, String>> _chartSeries = [
              new charts.Series(
                  id: "value",
                  data: series,
                  domainFn: (PieChartModel pie, _) => pie.option,
                  measureFn: (PieChartModel pie, _) => pie.optionCount,
                  labelAccessorFn: (PieChartModel pie, _) =>
                      "${pie.optionCount}(${((pie.optionCount / data.length) * 100).toStringAsFixed(0)} %)")
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
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  SizedBox(height: 16),
                  Text("${data.length} responses",
                      style: TextStyle(fontWeight: FontWeight.w400)),
                  SizedBox(height: 16),

                  Expanded(
                    // Chart
                    child: new charts.PieChart(
                      _chartSeries,
                      animate: true,
                      behaviors: [new charts.DatumLegend()],
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 60,
                        arcRendererDecorators: [new charts.ArcLabelDecorator()],
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
