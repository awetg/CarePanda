import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/HRmanagement/EditAddQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementQuestionnaire.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementInfoPage.dart';
import 'package:carePanda/pages/HRmanagement/HRmanagementMsgs.dart';
import 'package:flutter/material.dart';

import 'HRsurveyResponseList.dart';

class HRmanagementPage extends StatefulWidget {
  @override
  _HRmanagementPageState createState() => _HRmanagementPageState();
}

class _HRmanagementPageState extends State<HRmanagementPage> {
  var _showFloatButton = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => HRmanagementInfoPage()));
                },
              )
            ],
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  if (index == 0) {
                    _showFloatButton = true;
                  } else {
                    _showFloatButton = false;
                  }
                });
              },
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 2.0, color: Theme.of(context).accentColor),
              ),
              isScrollable: false,
              tabs: [
                Tab(
                    child: Text(
                        getTranslated(context, "hr_questionnaireTopBtn"),
                        style: TextStyle(fontSize: 16))),
                Tab(
                    child: Text(getTranslated(context, "hr_MsgsTopBtn"),
                        style: TextStyle(fontSize: 16))),
                Tab(
                    child: Text(
                  getTranslated(context, "hr_responsesBtn"),
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                )),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              // Shows messages, questionnaires or survey responses
              Column(
                children: [
                  QuestionnaireModification(),
                ],
              ),
              Column(
                children: [
                  Messages(),
                ],
              ),
              Column(
                children: [
                  HRsurveyResponses(),
                ],
              ),
            ],
          ),

          // Floating button -> opens page to add new questionnaire
          // When leaving the edit page, handles adding questionnaire
          // Gives array with null values
          floatingActionButton: _showFloatButton
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
                    setState(() {
                      print(DefaultTabController.of(context).index);
                    });
                  },
                  child: Icon(Icons.add),
                )
              : null),
    );
  }
}
