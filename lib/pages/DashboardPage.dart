import 'package:carePanda/extensions.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/widgets/LineChart.dart';
import 'package:carePanda/widgets/CardWidget.dart';

class DashBoardPage extends StatefulWidget {
  @override
  _DashBoardPageState createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  String _timePeriod = "Week";
  List<SurveyResponse> _graphData = [];

  // Filter graph data using time predicate
  // TODO: If time period filter for graph will be shipped as feature implement graphdata filtering
  _dataToShow() {
    if (_timePeriod == "Week") {
      // filter graph data with less than week timestam
    }
    if (_timePeriod == "Month") {
      // filter graph data with less than month timestam
    } else {
      // show all graph data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: StreamBuilder<List<SurveyResponse>>(
          stream: locator<FirestoreService>().getCurrentUserSurveyResponses(),
          builder: (context, snapshot) {
            // if there is current user specific answeres and it is not empty show graphs

            if (snapshot.hasData && snapshot.data.length > 0) {
              // filtering all ansewers that are type of RangeSelection or sldier input
              // TODO: change filtered response or answeres to more meaning full grouping
              _graphData = snapshot.data
                  .where((e) => e.type == QuestionType.RangeSelection)
                  .toList();

              // sort data
              _graphData
                  .sort((a, b) => a.time.toDate().compareTo(b.time.toDate()));

              _graphData.forEach(
                  (element) => print(element.time.toDate().toString()));

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Time period
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        "Personal data time period",
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
                    ]),
                    SizedBox(height: 20),

                    // Graph which is built inside card widget
                    ..._graphData
                        .groupBy((d) => d.questionId)
                        .entries
                        .map((e) => CardWidget(
                              widget: LineChart(data: e.value, title: e.key),
                            )),
                    SizedBox(height: 10),
                  ],
                ),
              );
            } else {
              print(
                  "ERROR: user dashborad page - No snapshot data from Firestore");
              // show there is not data card
              return Container();
            }
          }),
    );
  }
}
