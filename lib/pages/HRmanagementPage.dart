import 'dart:developer';

import 'package:carePanda/widgets/TopButton.dart';
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
                TopButton(
                  name: "Messages",
                  boolState: !_showMessages,
                  function: _showMessagesFunction,
                ),

                // Physical health button
                TopButton(
                  name: "Questionnaire",
                  boolState: _showMessages,
                  function: _showQuestionnairesFunction,
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
    new MsgDataStructure("Esko", "Aho", "building", 2, 23,
        "I need help with with this application", false, "male", 1),
    new MsgDataStructure("Seppo", "Aho", "building 1", 1, 22,
        "adsdasdaadsadsadsdasads", false, "male", 2),
    new MsgDataStructure(
        "Oskari",
        "Talvimaa",
        "building 1",
        3,
        22,
        "asdsadasdasdsadsadasdasdsadasdsadsaadasdasddasasddasdasadsadsadsads",
        null,
        "male",
        5),
    new MsgDataStructure("Joona", "Kumpu", "building 4", 40, 22,
        "asdjasddfgdfgsdfhfgjhd", false, null, null),
    new MsgDataStructure(null, "Kumpu", "Don't want to tell", null, 22,
        "asdjasddfgdfgsdfhfgjhd", false, "Don't want to tell", 1),
    new MsgDataStructure(
        "Jorma",
        null,
        "Don't want to tell",
        null,
        null,
        "asdjasdsadasdasdfhhadssasdadsssssssssssssssssssssssssssasd ad as as sadd sad asd s s dassda  dassd aad sad s ads a  adsa dss addasd as",
        false,
        "male",
        1),
    new MsgDataStructure("adsssssssssssssssssssssssssssssssssssssssasda", null,
        null, null, null, "Something happened", false, "male", null),
    new MsgDataStructure("asd ", null, "Building 13", null, null,
        "Something happened", false, null, 1),
    new MsgDataStructure(
        null,
        "asdads ada s ads addasad s adsads ads adsasasasdasd",
        null,
        null,
        null,
        "Something happened",
        false,
        null,
        null),
  ];

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
                          SizedBox(height: 6),

                          // Free space
                          msgData[index].expanded ?? false
                              ? SizedBox(height: 14)
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
                          if (msgData[index].gender != null ||
                              msgData[index].age != null)
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
                          if (msgData[index].yearsInNokia != null)
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

class MsgDataStructure {
  final String name;
  final String lastName;
  final String building;
  final int floor;
  final int age;
  final String message;
  final String gender;
  final int yearsInNokia;

  bool expanded;

  MsgDataStructure(this.name, this.lastName, this.building, this.floor,
      this.age, this.message, this.expanded, this.gender, this.yearsInNokia);
}
