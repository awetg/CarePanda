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
        const Text(
          "Thank you for completing the suvey!",
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
            child: const Text(
              "Your response will only be used in ways that does not identify you. We will use your feedback to understand your workplace better.",
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
