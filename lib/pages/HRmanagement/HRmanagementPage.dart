import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/HRmanagement/EditAddQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementInfoPage.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementMsgs.dart';
import 'package:carePanda/widgets/TopButton.dart';
import 'package:flutter/material.dart';

import 'HRsurveyResponseList.dart';

class HRmanagementPage extends StatefulWidget {
  @override
  _HRmanagementPageState createState() => _HRmanagementPageState();
}

class _HRmanagementPageState extends State<HRmanagementPage> {
  var _showMessages = false;
  var _showSurveyResponse = false;
  var _showQuestionnaire = true;

  // Shows questionnaires
  _showQuestionnairesFunction() {
    if (!_showQuestionnaire) {
      setState(() {
        _showQuestionnaire = true;
        _showMessages = false;
        _showSurveyResponse = false;
      });
    }
  }

  // Shows HR's messages
  _showMessagesFunction() {
    if (!_showMessages) {
      setState(() {
        _showQuestionnaire = false;
        _showMessages = true;
        _showSurveyResponse = false;
      });
    }
  }

  // Shows survey responses
  _showSurveyResponsesFunction() {
    if (!_showSurveyResponse) {
      setState(() {
        _showQuestionnaire = false;
        _showMessages = false;
        _showSurveyResponse = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "hr_managementTitle"),
            style: TextStyle(color: Theme.of(context).accentColor)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help_outline,
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => HRmanagementInfoPage()));
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Show questionnaire
                TopButton(
                  name: getTranslated(context, "hr_questionnaireTopBtn"),
                  boolState: !_showQuestionnaire,
                  function: _showQuestionnairesFunction,
                ),

                // Show messages
                TopButton(
                  name: getTranslated(context, "hr_MsgsTopBtn"),
                  boolState: !_showMessages,
                  function: _showMessagesFunction,
                ),

                // Show survey response
                TopButton(
                  name: getTranslated(context, "hr_responsesBtn"),
                  boolState: !_showSurveyResponse,
                  function: _showSurveyResponsesFunction,
                ),
              ],
            ),

            // Shows messages, questionnaires or survey responses
            if (_showQuestionnaire) QuestionnaireModification(),
            if (_showMessages) Messages(),
            if (_showSurveyResponse) HRsurveyResponses(),
          ],
        ),
      ),

      // Floating button -> opens page to add new questionnaire
      // When leaving the edit page, handles adding questionnaire
      // Gives array with null values
      floatingActionButton: _showQuestionnaire
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).accentColor,
              foregroundColor: Colors.white,
              onPressed: () async {
                await Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => EditAddQuestionnaire(
                      pageTitle: getTranslated(context, "hr_addQstTitle"),
                      questionnaireData: QuestionItem(),
                      editingExistingQuestionnaire: false,
                    ),
                  ),
                );
                setState(() {});
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
