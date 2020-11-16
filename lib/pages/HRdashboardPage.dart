import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/widgets/BarChart.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/widgets/LineChart.dart';
import 'package:carePanda/widgets/CardWidget.dart';
import 'package:carePanda/extensions.dart';

class HRdashboardPage extends StatefulWidget {
  @override
  _HRdashboardPageState createState() => _HRdashboardPageState();
}

class _HRdashboardPageState extends State<HRdashboardPage> {
  var _timePeriod = "Week";
  var _sortBy = "Building";
  List<SurveyResponse> _lineGraphData = [];
  List<SurveyResponse> _barGraphData = [];

  // Function to know what data to show
  _dataToShow() {
    if (_sortBy != "Time") {}
    if (_sortBy != "Time") {}
    if (_timePeriod == "Week") {}
    if (_timePeriod == "Month") {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR statistics',
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: StreamBuilder<List<SurveyResponse>>(
          stream: locator<FirestoreService>().getAllSurveyResponses(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data.length > 0) {
              print(
                  "HR dashbord snapshot not empty: ${snapshot.data.length} items");
              // filter range selection or slider question and assign to line graph data
              _lineGraphData = snapshot.data
                  .where((e) => e.type == QuestionType.RangeSelection)
                  .toList();

              // filter single selection or single choice question and assign to bar graph data
              _barGraphData = snapshot.data
                  .where((e) => e.type == QuestionType.SingleSelection)
                  .toList();

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Time period
                        Text(
                          "Data time period",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 18),
                        DropdownButton(
                          value: _timePeriod,
                          underline: Container(
                            height: 1,
                          ),
                          items: <String>["Week", 'Month', 'All']
                              .map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: 18.0),
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            // setState(() {
                            //   _timePeriod = newValue;
                            // });
                            _dataToShow();
                          },
                        ),
                        SizedBox(width: 18),
                      ],
                    ),
                    SizedBox(height: 20),
                    ..._lineGraphData
                        .groupBy((d) => d.questionId)
                        .entries
                        .map((e) => CardWidget(
                              widget: LineChart(data: e.value, title: e.key),
                            )),
                    ..._barGraphData
                        .groupBy((d) => d.questionId)
                        .entries
                        .map((e) => CardWidget(
                              widget: BarChart(data: e.value, title: e.key),
                            )),
                    SizedBox(height: 10),
                  ],
                ),
              );
            } else {
              print("HR dashbord snapshot is empty");
              // show error page
              return Container();
            }
          }),
    );
  }
}
