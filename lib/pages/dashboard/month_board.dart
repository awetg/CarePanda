import 'package:carePanda/model/board_type.dart';
import 'package:carePanda/model/graph_time_format.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/utils/time_util.dart';
import 'package:carePanda/widgets/BarChart.dart';
import 'package:carePanda/widgets/CardWidget.dart';
import 'package:carePanda/widgets/pie_chart.dart';
import 'package:carePanda/widgets/slider_bar_chart.dart';
import 'package:carePanda/widgets/time_series_chart.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/extensions.dart';
import 'board_title.dart';
import 'dashboard_empty_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// TODO: make board cycle through each month to show previous month data
class MonthBoard extends StatelessWidget {
  final List<SurveyResponse> monthGraphData;
  final BoardType type;
  final String boardTitle;
  const MonthBoard({this.monthGraphData, this.type, this.boardTitle});
  @override
  Widget build(BuildContext context) {
    if (monthGraphData.length > 0) {
      // filter range selection or slider question and assign to line graph data
      final _lineGraphData = monthGraphData
          .where((e) => e.type == QuestionType.RangeSelection)
          .toList();

      // filter single selection or single choice question and assign to bar graph data
      final _barGraphData = monthGraphData
          .where((e) => e.type == QuestionType.SingleSelection)
          .toList();

      final List<charts.TickSpec<DateTime>> staticTicks = [];

      final monthPair = TimeUtil.instance.getStartAndEndOfMonth(DateTime.now());

      for (var i = 0; i <= monthPair.second.day; i += 7) {
        staticTicks.add(
            charts.TickSpec<DateTime>(monthPair.first.add(Duration(days: i))));
      }

      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BoardTitle(
              title: boardTitle,
              count: monthGraphData.length,
            ),
            ..._lineGraphData
                .groupBy((d) => d.questionId)
                .entries
                .map((e) => CardWidget(
                      widget: type == BoardType.Personal
                          ? TimeSeriesChart(
                              data: e.value,
                              graphTimeFormat: GraphTimeFormat(
                                  timeFormat: "MMM d", tickSpec: staticTicks))
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
