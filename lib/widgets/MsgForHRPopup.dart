import 'package:carePanda/DataStructures/MsgDataStructure.dart';
import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class MsgForHRPopup extends StatefulWidget {
  @override
  _MsgForHRPopup createState() => _MsgForHRPopup();
}

class _MsgForHRPopup extends State<MsgForHRPopup> {
  var _anonymousMsg = false;
  var data;
  var _storageService = locator<LocalStorageService>();
  var _msg;

  _onAnonymousCheckBoxChange(bool value) {
    setState(() {
      _anonymousMsg = value;
    });
  }

  _sendMessage() {
    // Send message to firebase (if not anonymous, sends userdata with the msg)
    if (!_anonymousMsg) {
      data = new MsgDataStructure(
          name: _storageService.name,
          lastName: _storageService.lastName,
          building: _storageService.building,
          floor: _storageService.floor,
          age: _storageService.birthYear,
          message: _msg,
          expanded: false,
          gender: _storageService.gender,
          yearsInNokia: _storageService.yearsInNokia,
          date: DateTime.now().toString());
      log("isAnonymous: " + _anonymousMsg.toString());
    } else {
      data = new MsgDataStructure(
          name: "",
          lastName: "",
          building: 0,
          floor: 0,
          age: 0,
          message: _msg,
          expanded: false,
          gender: 0,
          yearsInNokia: 0,
          date: DateTime.now().toString());
      log("isAnonymous: " + _anonymousMsg.toString());
    }

    locator<FirestoreService>().saveHrMessage(data);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 5),
      title: Text(getTranslated(context, "msgForHR_title"),
          style: TextStyle(color: Theme.of(context).accentColor)),

      // Container with fixed width to make dialog wider
      content: Container(
        width: width - 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTileTheme(
              contentPadding: EdgeInsets.all(0),
              child: CheckboxListTile(
                title: Text(getTranslated(context, "msgForHR_sendMsgAnon")),
                value: _anonymousMsg,
                activeColor: Theme.of(context).accentColor,
                onChanged: _onAnonymousCheckBoxChange,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),

            SizedBox(height: 10),

            // Theme so that in light mode borders don't dissapear on focus
            Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: FractionallySizedBox(
                child: Container(
                  color: Theme.of(context).cardColor,
                  child: TextFormField(
                      onChanged: (value) {
                        _msg = value;
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                            ),
                          ),
                          hintText: getTranslated(context, "msgForHR_hint"))),
                ),
              ),
            ),
          ],
        ),
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text(getTranslated(context, "cancelBtn"),
              style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text(getTranslated(context, "submitBtn"),
              style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          onPressed: () {
            _sendMessage();
          },
        ),
      ],
    );
  }
}
