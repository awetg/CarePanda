import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/pages/survey/survey_flow.dart';
import 'package:carePanda/services/questionnaire_provider.dart';
import 'package:carePanda/widgets/Countdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Questionnaire extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionnairProvider>(
      builder: (context, questionnairProvider, child) => Container(
        height: 240,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).dialogBackgroundColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              questionnairProvider.getHasQuestionnaire()
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8.0, left: 16.0),
                          child: Text(
                            getTranslated(context, "home_userHasQst"),
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            getTranslated(context, "home_remainingQst"),
                          ),
                        )
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 8.0, left: 16.0),
                          child: Text(
                            "Come back later \u{1f600}",
                            style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).accentColor),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            getTranslated(context, "home_nextQst"),
                          ),
                        )
                      ],
                    ),
              Container(
                margin: EdgeInsets.only(top: 8.0, left: 16.0),
                child: WeekCountdown(
                  questionnaireStatusChanged: () {},
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 16.0, right: 16.0),
                      child: ElevatedButton(
                        onPressed: questionnairProvider.getHasQuestionnaire()
                            ? () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => SurveyFlow()));
                                questionnairProvider.setHasQuestionnaire(false);
                              }
                            : null,
                        child: Text(getTranslated(context, "home_answerBtn")),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(128, 36),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
