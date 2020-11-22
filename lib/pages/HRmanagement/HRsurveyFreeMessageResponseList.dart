import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SurveyFreeResponseList extends StatefulWidget {
  final questionID;

  SurveyFreeResponseList({@required this.questionID});

  @override
  _SurveyFreeResponseListState createState() => _SurveyFreeResponseListState();
}

class _SurveyFreeResponseListState extends State<SurveyFreeResponseList> {
  var _expandedOnesList = [];
  var _shouldExpand;

  var _allSurveyMsgResponses;
  var _amountOfResponses = 0;
  var _surveyResponse = [];

  _expandItem(int data) {
    setState(() {
      if (_expandedOnesList.contains(data)) {
        _expandedOnesList.remove(data);
      } else {
        _expandedOnesList.add(data);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "hr_freeResponTitle"),
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: StreamBuilder<List<SurveyResponse>>(
        stream: locator<FirestoreService>().getAllSurveyResponses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              _allSurveyMsgResponses = snapshot.data;

              // Sorting by date, newest to oldest
              _allSurveyMsgResponses
                  .sort((a, b) => b.time.compareTo(a.time) as int);

              // Loops through all survey responses to find responses with questionnaire's id
              // checks if free text is null or empty
              // if the map doesnt already contain the free text message, adds it in to the list
              for (var i = 0; i < _allSurveyMsgResponses.length; i++) {
                if (_allSurveyMsgResponses[i].freeText != "" &&
                    _allSurveyMsgResponses[i].freeText != null &&
                    _allSurveyMsgResponses[i].questionId == widget.questionID) {
                  if (_surveyResponse.any((a) => mapEquals(
                      a.toMap(), _allSurveyMsgResponses[i].toMap()))) {
                  } else {
                    _surveyResponse.add(_allSurveyMsgResponses[i]);
                    _amountOfResponses = _amountOfResponses + 1;
                  }
                }
              }

              // If there are no answers with free text message, show's "No responses"
              if (_amountOfResponses != 0) {
                return Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _amountOfResponses,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Boolean that determines is the card expanded or not
                      _shouldExpand = _expandedOnesList.contains(index);
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Card(
                          child: ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _surveyResponse[index].freeText ??
                                            getTranslated(context, "hr_error"),
                                        overflow: _shouldExpand ?? false
                                            ? null
                                            : TextOverflow.ellipsis,
                                        maxLines:
                                            _shouldExpand ?? false ? null : 2,
                                      ),
                                    ],
                                  ),
                                ),

                                // Icon
                                _shouldExpand ?? false
                                    ? Icon(Icons.expand_less, size: 28)
                                    : Icon(Icons.expand_more, size: 28),
                              ],
                            ),

                            // On tap expands card to show more data of message
                            onTap: () {
                              _expandItem(index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                // No free message responses
                return Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(getTranslated(context, "hr_freeResponNoRespon"),
                            style: TextStyle(fontSize: 24)),
                      ],
                    ));
              }
            } else {
              // No responses
              return Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getTranslated(context, "hr_freeResponNoRespon"),
                          style: TextStyle(fontSize: 24)),
                    ],
                  ));
            }
          } else {
            // Loading or can not fetch data (no internet)
            return Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
