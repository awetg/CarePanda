import 'package:flutter/material.dart';

class SimplePopUp extends StatefulWidget {
  final cancelBtnName;
  final confirmBtnName;
  final title;
  final confirmBtnColor;

  SimplePopUp(
      {@required this.cancelBtnName,
      @required this.confirmBtnName,
      @required this.title,
      this.confirmBtnColor});

  @override
  _SimplePopUp createState() => _SimplePopUp();
}

class _SimplePopUp extends State<SimplePopUp> {
  // On confirm, pops and returns true
  _onConfirm() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //contentPadding: EdgeInsets.only(left: 25, right: 25, top: 5, bottom: 5),
      title: Text(widget.title,
          style: TextStyle(color: Theme.of(context).accentColor)),

      // Buttons
      actions: [
        FlatButton(
          child: Text(widget.cancelBtnName, style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text(widget.confirmBtnName, style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          color: widget.confirmBtnColor ?? null,
          onPressed: () {
            _onConfirm();
          },
        ),
      ],
    );
  }
}
