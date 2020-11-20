import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/HRmanagement/EditAddQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementEditQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementInfoPage.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementMsgs.dart';
import 'package:carePanda/widgets/TopButton.dart';
import 'package:flutter/material.dart';

class HRmanagementPage extends StatefulWidget {
  @override
  _HRmanagementPageState createState() => _HRmanagementPageState();
}

class _HRmanagementPageState extends State<HRmanagementPage> {
  var _showMessages = false;

  // Shows questionnaires
  _showQuestionnairesFunction() {
    if (_showMessages) {
      setState(() {
        _showMessages = false;
      });
    }
  }

  // Shows HR's messages
  _showMessagesFunction() {
    if (!_showMessages) {
      setState(() {
        _showMessages = true;
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
                // Mental health button
                TopButton(
                  name: getTranslated(context, "hr_questionnaireTopBtn"),
                  boolState: _showMessages,
                  function: _showQuestionnairesFunction,
                ),

                // Physical health button
                TopButton(
                  name: getTranslated(context, "hr_MsgsTopBtn"),
                  boolState: !_showMessages,
                  function: _showMessagesFunction,
                ),
              ],
            ),

            // Shows messages or questionnaires
            if (_showMessages) Messages(),
            if (!_showMessages) QuestionnaireModification()
          ],
        ),
      ),

      // Floating button -> opens page to add new questionnaire
      // When leaving the edit page, handles adding questionnaire
      // Gives array with null values
      floatingActionButton: _showMessages
          ? null
          : FloatingActionButton(
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
            ),
    );
  }
}
