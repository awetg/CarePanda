import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PieChart extends StatelessWidget {
  final List<SurveyResponse> data;
  final String title;
  const PieChart({this.data, this.title});

  @override
  Widget build(BuildContext context) {
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

            // convert list of survey response to a list series
            final List<charts.Series<SurveyResponse, int>> _chartSeries = [
              new charts.Series(
                  id: "value",
                  data: data,
                  domainFn: (SurveyResponse res, _) => res.time.toDate().day,
                  // domainFn: (SurveyResponse res, _) => res.value,
                  measureFn: (SurveyResponse res, _) =>
                      question.options.indexOf(res.value) + 1,
                  labelAccessorFn: (SurveyResponse row, count) =>
                      '${row.value}: $count')
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
                    child: new charts.PieChart(_chartSeries,
                        animate: true,
                        defaultRenderer: new charts.ArcRendererConfig(
                            arcWidth: 60,
                            arcRendererDecorators: [
                              new charts.ArcLabelDecorator()
                            ])),
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
