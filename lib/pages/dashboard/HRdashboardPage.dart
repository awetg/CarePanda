import 'package:carePanda/model/board_type.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'dashboard_empty_page.dart';

class HRdashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TimeUtil.instance.hrTimePeriodTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('HR statistics',
              style: TextStyle(color: Theme.of(context).accentColor)),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).accentColor),
                insets: EdgeInsets.symmetric(horizontal: 32.0)),
            isScrollable: false,
            tabs: [
              for (final tab in TimeUtil.instance.hrTimePeriodTabs)
                Tab(
                  text: tab,
                )
            ],
          ),
        ),
        body: StreamBuilder<List<SurveyResponse>>(
            stream: locator<FirestoreService>().getAllSurveyResponses(),
            builder: (context, snapshot) {
              // if there is collected answeres from all users and it is more than one answer
              if (snapshot.hasData && snapshot.data.length > 1) {
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (final time in TimeUtil.instance.hrTimePeriodTabs)
                        TimeUtil.instance.getTimePeriodWidget(
                          time,
                          snapshot.data,
                          TimeUtil.instance.getBoardTitle(time),
                          BoardType.HR,
                        )
                    ]);
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // show error page
                return DasboardEmptyPage();
              }
            }),
      ),
    );
  }
}
