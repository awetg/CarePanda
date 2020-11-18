import 'package:carePanda/DataStructures/MsgDataStructure.dart';
import 'package:carePanda/DataStructures/QuestionnaireAddDataStructure.dart';
import 'package:carePanda/localization/localization.dart';
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
  var _questionnaireData = qstData;

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

  // Handles questionnaire adding
  _onNewQuestionnaireBack(newQuestionnaire) {
    setState(() {
      if (newQuestionnaire[1] == "Submit") {
        _questionnaireData.add(newQuestionnaire[0]);
      }
    });
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
            if (!_showMessages)
              QuestionnaireModification(newData: _questionnaireData)
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
                final newQst = await Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => EditAddQuestionnaire(
                              pageTitle:
                                  getTranslated(context, "hr_addQstTitle"),
                              questionnaireData: QuestionnaireAddDataStructure(
                                  null, null, null, null, null),
                            )));
                setState(() {
                  if (newQst != null) {
                    _onNewQuestionnaireBack(newQst);
                  }
                });
              },
              child: Icon(Icons.add),
            ),
    );
  }
}

class QuestionnaireModification extends StatefulWidget {
  final newData;

  QuestionnaireModification({this.newData});

  @override
  _QuestionnaireModificationState createState() =>
      _QuestionnaireModificationState();
}

class _QuestionnaireModificationState extends State<QuestionnaireModification> {
  var questionsData;

  @override
  void initState() {
    // Gets questionnaire data from parent and uses it to show questionnaires
    // ( Gets from parent because questionnaire adding is handeled in parent )
    questionsData = widget.newData;
    super.initState();
  }

  // Function runs when comes back from edit questionnaire page
  // Deletes or submmits questionnaire
  _onEditedQuestionnaireBack(
    editedQst,
    index,
  ) {
    setState(() {
      // Handle questionnaire editing
      if (editedQst[1] == "Submit") {
        questionsData[index] = editedQst[0];
      }
      // Handle questionnaire deleting
      if (editedQst == "Delete") {
        questionsData.removeAt(index);
      }
    });
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

  _questionTypeTranslation(value) {
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              getTranslated(context, "hr_currentQst"),
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
            SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: questionsData.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Card(
                      // Different shade of color for first questionnaire since it can not be edited
                      color: index < 1
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
                                    children: [
                                      Text(
                                        getTranslated(
                                            context, "hr_qstQuestion"),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      Flexible(
                                        child: Text(
                                          questionsData[index].question ?? " ",
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
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      Text(_trueOrFalseTranslation(
                                          questionsData[index].freeText)),
                                    ],
                                  ),

                                  // Free space
                                  SizedBox(height: 12),

                                  // Question type
                                  Row(
                                    children: [
                                      Text(
                                        getTranslated(context, "hr_qstQstType"),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                      ),
                                      Text(_questionTypeTranslation(
                                          questionsData[index].questionType)),
                                    ],
                                  ),

                                  // Free space
                                  if (questionsData[index].questionType ==
                                      "QuestionType.RangeSelection")
                                    SizedBox(height: 12),

                                  // If range selection , show's max range
                                  if (questionsData[index].questionType ==
                                      "QuestionType.RangeSelection")
                                    Row(
                                      children: [
                                        Text(
                                          getTranslated(
                                              context, "hr_qstMaxRange"),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text(
                                          questionsData[index]
                                                  .maxRange
                                                  .toString() ??
                                              "",
                                        ),
                                      ],
                                    ),

                                  // Free space
                                  if (questionsData[index].questionType ==
                                          "QuestionType.MultiSelection" ||
                                      questionsData[index].questionType ==
                                          "QuestionType.SingleSelection")
                                    SizedBox(height: 12),

                                  // If multi or single selection, show's options
                                  if (questionsData[index].questionType ==
                                          "QuestionType.MultiSelection" ||
                                      questionsData[index].questionType ==
                                          "QuestionType.SingleSelection")
                                    Row(
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
                                            questionsData[index]
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
                            // Icon for all but the first questionnaire
                            index > 0
                                ? Icon(Icons.navigate_next, size: 28)
                                : Icon(null)
                          ],
                        ),

                        // Ontap -> opens page to edit questionnaire
                        // Handles questionnaire edititing/deleting when coming back from edit page
                        onTap: index > 0
                            ? () async {
                                final editedQst = await Navigator.of(context,
                                        rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            EditAddQuestionnaire(
                                              pageTitle: getTranslated(
                                                  context, "hr_editQstTitle"),
                                              questionnaireData:
                                                  questionsData[index],
                                            )));
                                setState(() {
                                  if (editedQst != null) {
                                    _onEditedQuestionnaireBack(
                                        editedQst, index);
                                  }
                                });
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
  }
}

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _genderList;
  var _buildingList;
  var _length;
  var _data;
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
        if (snapshot.data != null) {
          // Length and data
          _length = snapshot.data.length;
          _data = snapshot.data;
          _data.sort((a, b) => b.date.compareTo(a.date) as int);

          return Container(
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _length,
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
                                      '${_data[index].name == "" ? "(No name)" : _data[index].name}  ${_data[index].lastName}',
                                      style: TextStyle(
                                          color: Theme.of(context).accentColor),
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 6),
                                  // Limits the message size (max 2 lines), when opened show's the entire message
                                  Text(
                                    _data[index].message,
                                    overflow: _shouldExpand ?? false
                                        ? null
                                        : TextOverflow.ellipsis,
                                    maxLines: _shouldExpand ?? false ? null : 2,
                                  ),
                                  SizedBox(height: 12),

                                  // Date
                                  Text(_data[index].date,
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
                                  if (_data[index].building != null)
                                    Row(
                                      children: [
                                        _shouldExpand ?? false
                                            ? Text(
                                                getTranslated(
                                                    context, "hr_msgBuilding"),
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
                                  if (_data[index].floor != null)
                                    _shouldExpand ?? false
                                        ? SizedBox(height: 8)
                                        : Container(),

                                  // Floor
                                  if (_data[index].floor != null)
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
                                                  (_data[index].floor == 0)
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
                                  if (_data[index].age != null &&
                                          _data[index].building != null ||
                                      _data[index].gender != null &&
                                          _data[index].building != null)
                                    _shouldExpand ?? false
                                        ? SizedBox(height: 8)
                                        : Container(),

                                  // Age
                                  Row(
                                    children: [
                                      if (_data[index].age != null)
                                        _shouldExpand ?? false
                                            ? Text(
                                                getTranslated(
                                                    context, "hr_msgAge"),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor))
                                            : Container(),

                                      if (_data[index].age != null)
                                        Flexible(
                                          child: _expandedOnesList
                                                      .contains(index) ??
                                                  false
                                              ? Text(
                                                  (_data[index].age == 0)
                                                      ? getTranslated(context,
                                                          "userData_notSelected")
                                                      : snapshot.data[index].age
                                                          .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Container(),
                                        ),

                                      // Free space between
                                      if (_data[index].age != null)
                                        _shouldExpand ?? false
                                            ? SizedBox(width: 10)
                                            : Container(),

                                      // gender
                                      if (_data[index].gender != null)
                                        _shouldExpand ?? false
                                            ? Text(
                                                getTranslated(
                                                    context, "hr_msgGender"),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor))
                                            : Container(),

                                      if (_data[index].gender != null)
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
                                          _data[index].building != null &&
                                          _data[index].age != null ||
                                      snapshot.data[index].yearsInNokia !=
                                              null &&
                                          _data[index].building != null &&
                                          _data[index].gender != null)
                                    _shouldExpand ?? false
                                        ? SizedBox(height: 8)
                                        : Container(),

                                  // Years in nokia
                                  if (_data[index].yearsInNokia != null)
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
                                                  (_data[index].yearsInNokia ==
                                                          0)
                                                      ? getTranslated(context,
                                                          "userData_notSelected")
                                                      : _data[index]
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
          return Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: CircularProgressIndicator(),
          );
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
