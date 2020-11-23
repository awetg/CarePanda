import 'package:carePanda/model/board_type.dart';
import 'package:carePanda/model/graph_time_format.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/pages/dashboard/board_title.dart';
import 'package:carePanda/widgets/BarChart.dart';
import 'package:carePanda/widgets/CardWidget.dart';
import 'package:carePanda/widgets/slider_bar_chart.dart';
import 'package:carePanda/widgets/pie_chart.dart';
import 'package:carePanda/widgets/time_series_chart.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/extensions.dart';
import 'dashboard_empty_page.dart';

// TODO: make board cycle through each day to show previous day data
class DayBoard extends StatelessWidget {
  final List<SurveyResponse> dayGraphData;
  final BoardType type;
  final String boardTitle;
  const DayBoard({this.dayGraphData, this.type, this.boardTitle});
  @override
  Widget build(BuildContext context) {
    if (dayGraphData.length > 0) {
      // filter range selection or slider question and assign to line graph data
      final _lineGraphData = dayGraphData
          .where((e) => e.type == QuestionType.RangeSelection)
          .toList();

      // filter single selection or single choice question and assign to bar graph data
      final _barGraphData = dayGraphData
          .where((e) => e.type == QuestionType.SingleSelection)
          .toList();

      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BoardTitle(
              title: boardTitle,
              count: dayGraphData.length,
            ),
            ..._lineGraphData
                .groupBy((d) => d.questionId)
                .entries
                .map((e) => CardWidget(
                      widget: type == BoardType.Personal
                          ? TimeSeriesChart(
                              data: e.value,
                              graphTimeFormat: GraphTimeFormat(timeFormat: "H"),
                            )
                          : SliderBarChart(data: e.value),
                    )),
            ..._barGraphData
                .groupBy((d) => d.questionId)
                .entries
                .map((e) => CardWidget(
                      widget: type == BoardType.Personal
                          ? BarChart(data: e.value)
                          : PieChart(data: e.value),
                    )),
            SizedBox(height: 10),
          ],
        ),
      );
    } else {
      return DasboardEmptyPage();
    }
  }
}
