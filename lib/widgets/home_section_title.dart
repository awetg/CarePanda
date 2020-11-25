import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String _title;
  const HomeSectionTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 64.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            child: Text(
              _title,
              style: TextStyle(
                  color: Theme.of(context).accentColor, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
