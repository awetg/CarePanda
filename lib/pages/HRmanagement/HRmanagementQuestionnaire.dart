import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/HRmanagement/EditAddQuestionnaire.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';

class QuestionnaireModification extends StatefulWidget {
  @override
  _QuestionnaireModificationState createState() =>
      _QuestionnaireModificationState();
}

class _QuestionnaireModificationState extends State<QuestionnaireModification> {
  var _questionsData;

  @override
  void initState() {
    super.initState();
  }

  // TRANSLATION FUNCTIONS

  // Translates true / false
  _trueOrFalseTranslation(value) {
    switch (value) {
      case true:
        return getTranslated(context, "hr_true");
      case false:
        return getTranslated(context, "hr_false");
      default:
        return getTranslated(context, "hr_error");
    }
  }

  // Translates question type
  _typeTranslation(value) {
    switch (value) {
      case "QuestionType.RangeSelection":
        return getTranslated(context, "hr_rangeSelection");
      case "QuestionType.SingleSelection":
        return getTranslated(context, "hr_singleSelection");
      case "QuestionType.MultiSelection":
        return getTranslated(context, "hr_multiSelection");
      default:
        return getTranslated(context, "hr_error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuestionItem>>(
      stream: locator<FirestoreService>().getSurveyQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
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
                  Text(
                    getTranslated(context, "hr_currentQst"),
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
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
                            color: _questionsData.length == index + 1
                                ? Theme.of(context).cardColor.withOpacity(0.65)
                                : null,
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
                                                  context, "hr_qstQuestion"),
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

                                        // Free space
                                        SizedBox(height: 12),

                                        // Free text boolean
                                        Row(
                                          children: [
                                            Text(
                                              getTranslated(
                                                  context, "hr_qstFreeText"),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            Text(_trueOrFalseTranslation(
                                                _questionsData[index]
                                                    .freeText)),
                                          ],
                                        ),

                                        // Free space
                                        SizedBox(height: 12),

                                        // Question type
                                        Row(
                                          children: [
                                            Text(
                                              getTranslated(
                                                  context, "hr_qstQstType"),
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                            ),
                                            Text(_typeTranslation(
                                                _questionsData[index]
                                                    .type
                                                    .toString())),
                                          ],
                                        ),

                                        // Free space
                                        if (_questionsData[index]
                                                    .type
                                                    .toString() ==
                                                "QuestionType.MultiSelection" ||
                                            _questionsData[index]
                                                    .type
                                                    .toString() ==
                                                "QuestionType.SingleSelection")
                                          SizedBox(height: 12),

                                        // If multi or single selection, show's options
                                        if (_questionsData[index]
                                                    .type
                                                    .toString() ==
                                                "QuestionType.MultiSelection" ||
                                            _questionsData[index]
                                                    .type
                                                    .toString() ==
                                                "QuestionType.SingleSelection")
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                getTranslated(
                                                    context, "hr_qstOptions"),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              ),
                                              Flexible(
                                                child: Text(
                                                  _questionsData[index]
                                                      .options
                                                      .toString()
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "")
                                                      .replaceAll('"', "")
                                                      .replaceAll(',', ",  "),
                                                ),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: 6),
                                      ],
                                    ),
                                  ),
                                  // Icon for all but the last questionnaire
                                  _questionsData.length != index + 1
                                      ? Icon(Icons.navigate_next, size: 28)
                                      : Icon(null)
                                ],
                              ),

                              // Ontap -> opens page to edit questionnaire
                              // Handles questionnaire edititing/deleting when coming back from edit page
                              onTap: _questionsData.length != index + 1
                                  ? () async {
                                      await Navigator.of(context,
                                              rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) =>
                                              EditAddQuestionnaire(
                                                  pageTitle: getTranslated(
                                                      context,
                                                      "hr_editQstTitle"),
                                                  questionnaireData:
                                                      _questionsData[index],
                                                  editingExistingQuestionnaire:
                                                      true),
                                        ),
                                      );
                                    }
                                  : null,
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
          // Shows loading indicator when loading
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator());
        } else {
          return Container(
              padding: EdgeInsets.only(top: 50),
              child: Text(getTranslated(context, "hr_qstNoQsts"),
                  style: TextStyle(fontSize: 24)));
        }
      },
    );
  }
}
