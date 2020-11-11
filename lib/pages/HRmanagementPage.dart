import 'dart:developer';

import 'package:flutter/material.dart';

class HRmanagementPage extends StatefulWidget {
  @override
  _HRmanagementPageState createState() => _HRmanagementPageState();
}

class _HRmanagementPageState extends State<HRmanagementPage> {
  var _showMessages = true;

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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 3,
                            color: _showMessages
                                ? Theme.of(context).accentColor
                                : Colors.transparent),
                      ),
                    ),
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: const Text('Messages',
                          style: TextStyle(fontSize: 18)),
                      color: Theme.of(context).canvasColor,
                      textColor: Theme.of(context).textTheme.bodyText1.color,
                      elevation: 0,
                      onPressed: () {
                        _showMessagesFunction();
                      },
                    ),
                  ),
                ),

                // Physical health button
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 3,
                            color: _showMessages
                                ? Colors.transparent
                                : Theme.of(context).accentColor),
                      ),
                    ),
                    child: RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: const Text('Questionnaire',
                          style: TextStyle(fontSize: 18)),
                      color: Theme.of(context).canvasColor,
                      textColor: Theme.of(context).textTheme.bodyText1.color,
                      elevation: 0,
                      onPressed: () {
                        _showQuestionnairesFunction();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (_showMessages) Messages()
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
  List<MsgDataStructure> msgData = [
    new MsgDataStructure("Esko", "Aho", "building", 23,
        "I need help with with this application", false),
    new MsgDataStructure(
        "Seppo", "Aho", "building 1", 22, "adsdasdaadsadsadsdasads", false),
    new MsgDataStructure(
        "Oskari",
        "Talvimaa",
        "building 1",
        22,
        "asdsadasdasdsadsadasdasdsadasdsadsaadasdasddasasddasdasadsadsadsads",
        null),
    new MsgDataStructure(
        "Joona", "Kumpu", "building 4", 22, "asdjasddfgdfgsdfhfgjhd", false),
    new MsgDataStructure(null, "Kumpu", "Don't want to tell", 22,
        "asdjasddfgdfgsdfhfgjhd", false),
    new MsgDataStructure(
        "Jorma",
        null,
        "Don't want to tell",
        null,
        "asdjasdsadasdasdfhhadssasdadsssssssssssssssssssssssssssasd ad as as sadd sad asd s s dassda  dassd aad sad s ads a  adsa dss addasd as",
        false),
    new MsgDataStructure("adsssssssssssssssssssssssssssssssssssssssasda", null,
        null, null, "Something happened", false),
    new MsgDataStructure("asd ", null, null, null, "Something happened", false),
    new MsgDataStructure(
        null,
        "asdads ada s ads addasad s adsads ads adsasasasdasd",
        null,
        null,
        "Something happened",
        false),
  ];

  _expandItem(MsgDataStructure msgData) {
    setState(() {
      if (msgData.expanded == null) {
        msgData.expanded = false;
      }
      msgData.expanded = !msgData.expanded;
    });
    log(msgData.name.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: msgData.length,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6),
                        Text(
                            '${msgData[index].name ?? "(No name)"}  ${msgData[index].lastName ?? ""}',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                            overflow: TextOverflow.ellipsis),
                        SizedBox(height: 6),
                        // Limits the message size, when opened show's the entire message
                        Text(
                          msgData[index].message,
                          overflow: msgData[index].expanded ?? false
                              ? null
                              : TextOverflow.ellipsis,
                          maxLines: msgData[index].expanded ?? false ? null : 2,
                        ),
                        SizedBox(height: 6),

                        // Free space
                        msgData[index].expanded ?? false
                            ? SizedBox(height: 8)
                            : Container(),

                        // Building
                        Row(
                          children: [
                            msgData[index].expanded ?? false
                                ? Text('Building: ',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))
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

                        // Free space between age/building
                        msgData[index].expanded ?? false
                            ? SizedBox(height: 8)
                            : Container(),

                        // Age
                        Row(
                          children: [
                            msgData[index].expanded ?? false
                                ? Text('Age: ',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor))
                                : Container(),
                            msgData[index].expanded ?? false
                                ? Text(
                                    '${msgData[index].age ?? "Don't want to tell"}',
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : Container(),
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
          );
        },
      ),
    );
  }
}

class MsgDataStructure {
  final String name;
  final String lastName;
  final String building;
  final int age;
  final String message;

  bool expanded;

  MsgDataStructure(this.name, this.lastName, this.building, this.age,
      this.message, this.expanded);
}
