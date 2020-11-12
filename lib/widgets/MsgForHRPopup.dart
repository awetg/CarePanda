import 'package:flutter/material.dart';
import 'dart:developer';

class MsgForHRPopup extends StatefulWidget {
  @override
  _MsgForHRPopup createState() => _MsgForHRPopup();
}

class _MsgForHRPopup extends State<MsgForHRPopup> {
  var _anonymousMsg = false;

  _onAnonymousCheckBoxChange(bool value) {
    setState(() {
      _anonymousMsg = value;
    });
  }

  _sendMessage() {
    // Send message to firebase (if not anonymous, sends userdata with the msg)
    if (!_anonymousMsg) {
      log("isAnonymous: " + _anonymousMsg.toString());
    } else {
      log("isAnonymous: " + _anonymousMsg.toString());
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 5),
      title: Text("Send a message for HR",
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
                title: Text("Send message anonymously"),
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
                child: TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
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
                        hintText: "Optional free text")),
              ),
            ),
          ],
        ),
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text("Cancel", style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: const Text('Send', style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          onPressed: () {
            _sendMessage();
          },
        ),
      ],
    );
  }
}
