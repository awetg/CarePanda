import 'dart:convert';
import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/hr_message.dart';
import 'package:carePanda/model/user_data.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';

class MsgForHRPopup extends StatefulWidget {
  @override
  _MsgForHRPopup createState() => _MsgForHRPopup();
}

class _MsgForHRPopup extends State<MsgForHRPopup> {
  final _formKey = GlobalKey<FormState>();
  var _anonymousMsg = false;
  HRMessage data;
  var _storageService = locator<LocalStorageService>();
  var _msg;

  // Sends message
  _sendMessage() {
    // Send message to firebase (if not anonymous, sends userdata with the msg)
    if (!_anonymousMsg) {
      String prevData = _storageService.userData;
      UserData userData = prevData != null
          ? UserData.fromMap(json.decode(prevData))
          : UserData();
      data = new HRMessage(
        name: userData.name,
        lastName: userData.lastName,
        building: userData.building,
        floor: userData.floor,
        birthYear: userData.birthYear,
        message: _msg,
        gender: userData.gender,
        yearsWorked: userData.yearsWorked,
        date: DateTime.now().toString(),
      );
    } else {
      data = new HRMessage(
        name: "",
        lastName: "",
        building: "-1",
        floor: "-1",
        birthYear: "-1",
        message: _msg,
        gender: "-1",
        yearsWorked: "-1",
        date: DateTime.now().toString(),
      );
    }
    if (_formKey.currentState.validate()) {
      locator<FirestoreService>().saveHrMessage(data);
      Navigator.of(context).pop();
    }
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
                onChanged: (value) => setState(() {
                  _anonymousMsg = value;
                }),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ),

            SizedBox(height: 10),

            // Theme so that in light mode borders don't dissapear on focus
            Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: Form(
                key: _formKey,
                child: TextFormField(
                    onChanged: (value) {
                      _msg = value;
                    },
                    validator: (value) {
                      // Checks that message is not empty
                      if (value.trim().isEmpty)
                        return getTranslated(context, "msgForHr_noMsg");
                      return null;
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        hintText: getTranslated(context, "msgForHR_hint"))),
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
