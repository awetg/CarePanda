import 'dart:developer';

import 'package:carePanda/DataStructures/MsgDataStructure.dart';
import 'package:carePanda/DataStructures/QuestionnaireAddDataStructure.dart';
import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/EditAddQuestionnaire.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
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
                  name: getTranslated(context, "hr_MsgsTopeBtn"),
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

class QuestionnaireModification extends StatefulWidget {
  @override
  _QuestionnaireModificationState createState() =>
      _QuestionnaireModificationState();
}

class _QuestionnaireModificationState extends State<QuestionnaireModification> {
  var _questionsData;
  var _editableQuestionnaire = 0;

  @override
  void initState() {
    super.initState();
  }

  // TRANSLATION FUNCTIONS
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
          if (snapshot.hasData) {
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
                          color: Theme.of(context).accentColor, fontSize: 20),
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
                                  ? Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.65)
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
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _genderList;
  var _buildingList;
  var _msgData;
  var _expandedOnesList = [];
  var _shouldExpand;

  // Expanding card
  // Inserts into empty list all the indexes that should be expanded and use the list to determine which to expand
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

    _genderList = [
      getTranslated(context, "userData_dontWnaTell"),
      getTranslated(context, "userData_male"),
      getTranslated(context, "userData_female"),
      getTranslated(context, "userData_other")
    ];

    _buildingList = [
      getTranslated(context, "userData_dontWnaTell"),
      getTranslated(context, "userData_workFromHome"),
      "Karaportti 4",
      "Karaportti 8",
      "KaraEast (Building 12)",
      "Mid Point 7A",
      "Mid Point 7B",
      "Mid Point 7C"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MsgDataStructure>>(
      stream: locator<FirestoreService>().getAllHrMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Sets data to variable and sorts it by date
          if (snapshot.data.isNotEmpty) {
            _msgData = snapshot.data;
            _msgData.sort((a, b) => b.date.compareTo(a.date) as int);

            return Container(
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _msgData.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),

                                    // Name and last name
                                    Text(
                                        '${_msgData[index].name == "" ? "(No name)" : _msgData[index].name}  ${_msgData[index].lastName}',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 6),
                                    // Limits the message size (max 2 lines), when opened show's the entire message
                                    Text(
                                      _msgData[index].message,
                                      overflow: _shouldExpand ?? false
                                          ? null
                                          : TextOverflow.ellipsis,
                                      maxLines:
                                          _shouldExpand ?? false ? null : 2,
                                    ),
                                    SizedBox(height: 12),

                                    // Date
                                    Text(_msgData[index].date,
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .color)),

                                    // Free space
                                    _shouldExpand ?? false
                                        ? SizedBox(height: 10)
                                        : Container(),

                                    // Building
                                    if (_msgData[index].building != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(context,
                                                      "hr_msgBuilding"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    _buildingList[snapshot
                                                        .data[index].building],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    // Free space
                                    if (_msgData[index].floor != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Floor
                                    if (_msgData[index].floor != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgFloor"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index].floor == 0)
                                                        ? getTranslated(context,
                                                            "userData_dontWnaTell")
                                                        : snapshot
                                                            .data[index].floor
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    // Free space
                                    if (_msgData[index].birthYear != null &&
                                            _msgData[index].building != null ||
                                        _msgData[index].gender != null &&
                                            _msgData[index].building != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Age
                                    Row(
                                      children: [
                                        if (_msgData[index].birthYear != null)
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgAge"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),

                                        if (_msgData[index].birthYear != null)
                                          Flexible(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index]
                                                                .birthYear ==
                                                            0)
                                                        ? getTranslated(context,
                                                            "userData_notSelected")
                                                        : snapshot.data[index]
                                                            .birthYear
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),

                                        // Free space between
                                        if (_msgData[index].birthYear != null)
                                          _shouldExpand ?? false
                                              ? SizedBox(width: 10)
                                              : Container(),

                                        // gender
                                        if (_msgData[index].gender != null)
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgGender"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),

                                        if (_msgData[index].gender != null)
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    _genderList[snapshot
                                                        .data[index].gender],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  )
                                                : Container(),
                                          ),
                                      ],
                                    ),

                                    // Free space between
                                    if (snapshot.data[index].yearsInNokia !=
                                                null &&
                                            _msgData[index].building != null &&
                                            _msgData[index].birthYear != null ||
                                        snapshot.data[index].yearsInNokia !=
                                                null &&
                                            _msgData[index].building != null &&
                                            _msgData[index].gender != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Years in nokia
                                    if (_msgData[index].yearsInNokia != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(context,
                                                      "hr_msgYearsWorkedNokia"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index]
                                                                .yearsInNokia ==
                                                            0)
                                                        ? getTranslated(context,
                                                            "userData_notSelected")
                                                        : _msgData[index]
                                                            .yearsInNokia
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    SizedBox(height: 6),
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
              ),
            );
          } else {
            return Container(
                padding: EdgeInsets.only(top: 50),
                child: Text(getTranslated(context, "hr_msgNoMsgs"),
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

List<QuestionnaireAddDataStructure> qstData = [
  new QuestionnaireAddDataStructure(
      true, "How's your day?", "QuestionType.RangeSelection", null, 10),
  new QuestionnaireAddDataStructure(true, "How's your workload?",
      "QuestionType.SingleSelection", '["Yes","No"]', null),
  new QuestionnaireAddDataStructure(false, "How you feeling?",
      "QuestionType.MultiSelection", '["Good","Bad","Can not say"]', null),
  new QuestionnaireAddDataStructure(true, "How you tomorrow?",
      "QuestionType.MultiSelection", '["Good","Bad","Can not say"]', null),
];
