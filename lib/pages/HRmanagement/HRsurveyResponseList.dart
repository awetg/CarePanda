import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/HRmanagement/HRsurveyFreeMessageResponseList.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';

class HRsurveyResponses extends StatefulWidget {
  @override
  _HRsurveyResponsesState createState() => _HRsurveyResponsesState();
}

class _HRsurveyResponsesState extends State<HRsurveyResponses> {
  var _questionsData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuestionItem>>(
      stream: locator<FirestoreService>().getSurveyQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isNotEmpty) {
            _questionsData = snapshot.data;

            // Sorting by date, newest to oldest
            _questionsData.sort((a, b) => b.date.compareTo(a.date) as int);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Text(
                        getTranslated(context, "hr_responseTitle"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 6),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _questionsData.length,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Card(
                              // Different shade of color for first questionnaire since it can not be edited

                              child: ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          // Free space
                                          SizedBox(height: 6),

                                          // Question text
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    context, "hr_responseQst"),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  _questionsData[index]
                                                          .question ??
                                                      " ",
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Icon for all but the last questionnaire
                                    Icon(Icons.navigate_next, size: 28)
                                  ],
                                ),

                                // Ontap -> opens page to edit questionnaire
                                // Handles questionnaire edititing/deleting when coming back from edit page
                                onTap: () async {
                                  await Navigator.of(context,
                                          rootNavigator: true)
                                      .push(
                                    MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) =>
                                          SurveyFreeResponseList(
                                              questionID:
                                                  _questionsData[index].id,
                                              question: _questionsData[index]
                                                  .question),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(getTranslated(context, "hr_qstNoQsts"),
                    style: TextStyle(fontSize: 24)));
          }
        } else {
          return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator());
        }
      },
    );
  }
}
