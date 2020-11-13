import 'package:carePanda/DataStructures/MsgDataStructure.dart';
import 'package:carePanda/DataStructures/QuestionnaireAddDataStructure.dart';
import 'package:carePanda/pages/EditAddQuestionnaire.dart';
import 'package:carePanda/widgets/TopButton.dart';
import 'package:flutter/material.dart';

class HRmanagementPage extends StatefulWidget {
  @override
  _HRmanagementPageState createState() => _HRmanagementPageState();
}

class _HRmanagementPageState extends State<HRmanagementPage> {
  var _showMessages = false;

  _showQuestionnairesFunction() {
    if (_showMessages) {
      setState(() {
        _showMessages = false;
      });
    }
  }

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
        title: Text('HR management',
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
                  name: "Questionnaire",
                  boolState: _showMessages,
                  function: _showQuestionnairesFunction,
                ),

                // Physical health button
                TopButton(
                  name: "Messages",
                  boolState: !_showMessages,
                  function: _showMessagesFunction,
                ),
              ],
            ),
            if (_showMessages) Messages(),
            if (!_showMessages) QuestionnaireModification()
          ],
        ),
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
              "Current questionnaires",
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
            SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: qstData.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Card(
                      child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          "Question: ",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Flexible(
                                          child: Text(
                                            qstData[index].question,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          "Free text: ",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text(
                                          qstData[index].freeText.toString(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Text(
                                          "Question type: ",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                        ),
                                        Text(
                                          qstData[index]
                                              .questionType
                                              .toString()
                                              .toString()
                                              .replaceAll("QuestionType.", "")
                                              .replaceAll(
                                                  "Selection", " selection"),
                                        ),
                                      ],
                                    ),

                                    // Free space
                                    if (qstData[index].questionType ==
                                        "QuestionType.RangeSelection")
                                      SizedBox(height: 12),

                                    // If range selection , show's max range
                                    if (qstData[index].questionType ==
                                        "QuestionType.RangeSelection")
                                      Row(
                                        children: [
                                          Text(
                                            "Max range: ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            qstData[index].maxRange.toString(),
                                          ),
                                        ],
                                      ),

                                    // Free space
                                    if (qstData[index].questionType ==
                                            "QuestionType.MultiSelection" ||
                                        qstData[index].questionType ==
                                            "QuestionType.SingleSelection")
                                      SizedBox(height: 12),

                                    // If multi or single selection, show's options
                                    if (qstData[index].questionType ==
                                            "QuestionType.MultiSelection" ||
                                        qstData[index].questionType ==
                                            "QuestionType.SingleSelection")
                                      Row(
                                        children: [
                                          Text(
                                            "Options: ",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .accentColor),
                                          ),
                                          Text(
                                            qstData[index]
                                                .options
                                                .toString()
                                                .replaceAll("[", "")
                                                .replaceAll("]", "")
                                                .replaceAll('"', "")
                                                .replaceAll(',', ",  "),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                              Icon(Icons.navigate_next, size: 28)
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAddQuestionnaire(
                                        pageTitle: "Edit questionnaire",
                                        questionnaireData: qstData[index],
                                        callBackFunction: () {
                                          setState(() {});
                                        })));
                          }),
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
  _expandItem(MsgDataStructure msgData) {
    setState(() {
      if (msgData.expanded == null) {
        msgData.expanded = false;
      }
      msgData.expanded = !msgData.expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: msgData.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
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
                              '${msgData[index].name ?? "(No name)"}  ${msgData[index].lastName ?? ""}',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor),
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: 6),
                          // Limits the message size (max 2 lines), when opened show's the entire message
                          Text(
                            msgData[index].message,
                            overflow: msgData[index].expanded ?? false
                                ? null
                                : TextOverflow.ellipsis,
                            maxLines:
                                msgData[index].expanded ?? false ? null : 2,
                          ),
                          SizedBox(height: 12),

                          // Date
                          Text(msgData[index].date,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),

                          // Free space
                          msgData[index].expanded ?? false
                              ? SizedBox(height: 10)
                              : Container(),

                          // Building
                          if (msgData[index].building != null)
                            Row(
                              children: [
                                msgData[index].expanded ?? false
                                    ? Text('Building: ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                    : Container(),
                                Expanded(
                                  child: msgData[index].expanded ?? false
                                      ? Text(
                                          '${msgData[index].building ?? "Don't want to tell"}',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )
                                      : Container(),
                                ),
                              ],
                            ),

                          // Free space
                          if (msgData[index].floor != null)
                            msgData[index].expanded ?? false
                                ? SizedBox(height: 8)
                                : Container(),

                          // Floor
                          if (msgData[index].floor != null)
                            Row(
                              children: [
                                msgData[index].expanded ?? false
                                    ? Text('Floor: ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                    : Container(),
                                Expanded(
                                  child: msgData[index].expanded ?? false
                                      ? Text(
                                          '${msgData[index].floor ?? ""}',
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Container(),
                                ),
                              ],
                            ),

                          // Free space
                          if (msgData[index].age != null &&
                                  msgData[index].building != null ||
                              msgData[index].gender != null &&
                                  msgData[index].building != null)
                            msgData[index].expanded ?? false
                                ? SizedBox(height: 8)
                                : Container(),

                          // Age
                          Row(
                            children: [
                              if (msgData[index].age != null)
                                msgData[index].expanded ?? false
                                    ? Text('Age: ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                    : Container(),

                              if (msgData[index].age != null)
                                Flexible(
                                  child: msgData[index].expanded ?? false
                                      ? Text(
                                          '${msgData[index].age ?? "Don't want to tell"}',
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Container(),
                                ),

                              // Free space between
                              if (msgData[index].age != null)
                                msgData[index].expanded ?? false
                                    ? SizedBox(width: 10)
                                    : Container(),

                              // gender
                              if (msgData[index].gender != null)
                                msgData[index].expanded ?? false
                                    ? Text('Gender: ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                    : Container(),

                              if (msgData[index].gender != null)
                                Expanded(
                                  child: msgData[index].expanded ?? false
                                      ? Text(
                                          '${msgData[index].gender ?? "Don't want to tell"}',
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Container(),
                                ),
                            ],
                          ),

                          // Free space between
                          if (msgData[index].yearsInNokia != null &&
                                  msgData[index].building != null &&
                                  msgData[index].age != null ||
                              msgData[index].yearsInNokia != null &&
                                  msgData[index].building != null &&
                                  msgData[index].gender != null)
                            msgData[index].expanded ?? false
                                ? SizedBox(height: 8)
                                : Container(),

                          // Years in nokia
                          if (msgData[index].yearsInNokia != null)
                            Row(
                              children: [
                                msgData[index].expanded ?? false
                                    ? Text('Years worked in Nokia: ',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor))
                                    : Container(),
                                Expanded(
                                  child: msgData[index].expanded ?? false
                                      ? Text(
                                          '${msgData[index].yearsInNokia ?? ""}',
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Container(),
                                ),
                              ],
                            ),

                          SizedBox(height: 6),
                        ],
                      ),
                    ),
                    msgData[index].expanded ?? false
                        ? Icon(Icons.expand_less, size: 28)
                        : Icon(Icons.expand_more, size: 28),
                  ],
                ),
                onTap: () {
                  _expandItem(msgData[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

List<QuestionnaireAddDataStructure> qstData = [
  new QuestionnaireAddDataStructure(
      true, "How's your day?", "QuestionType.RangeSelection", null, 10),
  new QuestionnaireAddDataStructure(true, "How's your workload?",
      "QuestionType.SingleSelection", '["Yes","No"]', null),
  new QuestionnaireAddDataStructure(true, "How you feeling?",
      "QuestionType.MultiSelection", '["Good","Bad","Can not say"]', null),
  new QuestionnaireAddDataStructure(
      true,
      "How you feeling and how you doing and how you working and are you stressed?",
      "QuestionType.MultiSelection",
      '["Good","Bad","Can not say"]',
      null),
];

List<MsgDataStructure> msgData = [
  new MsgDataStructure("Esko", "Aho", "building", 2, 23,
      "I need help with with this application", false, "male", 1, "10.13.2020"),
  new MsgDataStructure("Seppo", "Aho", "building 1", 1, 22,
      "adsdasdaadsadsadsdasads", false, "male", 2, "10.13.2020"),
  new MsgDataStructure(
      "Oskari",
      "Talvimaa",
      "building 1",
      3,
      22,
      "asdsadasdasdsadsadasdasdsadasdsadsaadasdasddasasddasdasadsadsadsads",
      null,
      "male",
      5,
      "10.13.2020"),
  new MsgDataStructure("Joona", "Kumpu", "building 4", 40, 22,
      "asdjasddfgdfgsdfhfgjhd", false, null, null, "10.13.2020"),
  new MsgDataStructure(null, "Kumpu", "Don't want to tell", null, 22,
      "asdjasddfgdfgsdfhfgjhd", false, "Don't want to tell", 1, "10.13.2020"),
  new MsgDataStructure(
      "Jorma",
      null,
      "Don't want to tell",
      null,
      null,
      "asdjasdsadasdasdfhhadssasdadsssssssssssssssssssssssssssasd ad as as sadd sad asd s s dassda  dassd aad sad s ads a  adsa dss addasd as",
      false,
      "male",
      1,
      "10.13.2020"),
  new MsgDataStructure(
      "adsssssssssssssssssssssssssssssssssssssssasda",
      null,
      null,
      null,
      null,
      "Something happened",
      false,
      "male",
      null,
      "10.13.2020"),
  new MsgDataStructure("asd ", null, null, null, null, "Something happened",
      false, null, 1, "10.13.2020"),
  new MsgDataStructure(
      null,
      "asdads ada s ads addasad s adsads ads adsasasasdasd",
      null,
      null,
      null,
      "Something happened",
      false,
      null,
      null,
      "10.13.2020"),
];
