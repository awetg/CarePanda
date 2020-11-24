import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/board_type.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/pages/dashboard/dashboard_empty_page.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/utils/time_util.dart';
import 'package:flutter/material.dart';

class DashBoardPage extends StatelessWidget {
  _tabNameTranslated(tab, context) {
    switch (tab) {
      case "Week":
        return getTranslated(context, "graph_week");
      case "Month":
        return getTranslated(context, "graph_month");
      case "Year":
        return getTranslated(context, "graph_year");
      default:
        return "Error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TimeUtil.instance.hrTimePeriodTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "graph_dashboardTitle"),
              style: TextStyle(color: Theme.of(context).accentColor)),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).accentColor),
                insets: EdgeInsets.symmetric(horizontal: 32.0)),
            isScrollable: false,
            tabs: [
              for (final tab in TimeUtil.instance.personalTimePeriodTabs)
                Tab(
                  text: _tabNameTranslated(tab, context),
                )
            ],
          ),
        ),
        body: StreamBuilder<List<SurveyResponse>>(
            stream: locator<FirestoreService>().getCurrentUserSurveyResponses(),
            builder: (context, snapshot) {
              // if there is current user have previous answers and it is more than one answer
              if (snapshot.hasData && snapshot.data.length > 1) {
                return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      for (final time
                          in TimeUtil.instance.personalTimePeriodTabs)
                        TimeUtil.instance.getTimePeriodWidget(
                          time,
                          snapshot.data,
                          TimeUtil.instance.getBoardTitle(time),
                          BoardType.Personal,
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
