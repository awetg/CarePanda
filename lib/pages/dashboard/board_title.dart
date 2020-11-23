import 'package:flutter/material.dart';

class BoardTitle extends StatelessWidget {
  final String title;
  final int count;
  const BoardTitle({this.title, this.count});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 8),
        Text(
          "$count responses",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
