import 'package:flutter/material.dart';

// A progress indicator for survey/questionnaire flow
class QuestionProgressIndicator extends StatelessWidget {
  final int positionIndex, currentIndex;
  const QuestionProgressIndicator({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          height: 6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: positionIndex <= currentIndex
                  ? Colors.blue
                  : Colors.blue[100]),
        ),
      ]),
    );
  }
}
