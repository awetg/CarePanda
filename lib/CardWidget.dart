import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  CardWidget({this.widget});
  final widget;

  //final cardColor = Color(0xffD7E0EB);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Theme.of(context).cardColor,
        child: widget,
      ),
    );
  }
}
