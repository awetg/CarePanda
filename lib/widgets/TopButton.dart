import 'package:flutter/material.dart';

class TopButton extends StatelessWidget {
  final String name;
  final bool boolState;
  final function;

  TopButton({this.name, this.boolState, this.function});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                width: 3,
                color: boolState
                    ? Colors.transparent
                    : Theme.of(context).accentColor),
          ),
        ),
        child: RaisedButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Text(name, style: TextStyle(fontSize: 16)),
          color: Theme.of(context).canvasColor,
          textColor: Theme.of(context).textTheme.bodyText1.color,
          elevation: 0,
          onPressed: function,
        ),
      ),
    );
  }
}
