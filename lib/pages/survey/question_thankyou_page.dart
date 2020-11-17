import 'package:carePanda/localization/localization.dart';
import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/thank_you.png"))),
        ),
        SizedBox(
          height: 60.0,
        ),
        Text(
          getTranslated(context, "qst_tyTitle"),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              getTranslated(context, "qst_tyText"),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
                letterSpacing: 1.5,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
