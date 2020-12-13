import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/reportMsgModel.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ReportBugPopup extends StatefulWidget {
  @override
  _ReportBugPopup createState() => _ReportBugPopup();
}

class _ReportBugPopup extends State<ReportBugPopup> {
  var _msg;
  var _validMsg = false;
  var _hasTriedToSendMsg = false;

  // Sends bug report
  _sendBugReport() {
    setState(() {
      _hasTriedToSendMsg = true;
    });

    var data =
        new ReportMsgModel(message: _msg, date: DateTime.now().toString());

    // If message is valid, sends bug report
    if (_validMsg) {
      locator<FirestoreService>().saveReportBugMsg(data);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 5),
      title: Text(getTranslated(context, "reportBug_title"),
          style: TextStyle(color: Theme.of(context).accentColor)),

      // Container with fixed width to make dialog wider
      content: Container(
        width: width - 100,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Theme so that in light mode borders don't dissapear on focus
            Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: TextFormField(
                  onChanged: (value) {
                    _msg = value;
                  },
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    // Checks that message is not empty
                    if (_hasTriedToSendMsg) {
                      if (value.replaceAll(new RegExp(r"\s+"), "").isEmpty) {
                        _validMsg = false;
                        return getTranslated(context, "reportBug_noMsg");
                      } else {
                        _validMsg = true;
                        return null;
                      }
                    }
                    if (value.replaceAll(new RegExp(r"\s+"), "").isNotEmpty) {
                      _validMsg = true;
                    }
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
                      hintText: getTranslated(context, "reportBug_hint"))),
            ),
            SizedBox(height: 8),

            // Privacy message
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(getTranslated(context, "reportBug_privacy"),
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).accentColor)),
                ),
              ],
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
            _sendBugReport();
          },
        ),
      ],
    );
  }
}
