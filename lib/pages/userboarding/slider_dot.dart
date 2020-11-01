import 'package:flutter/material.dart';

// A dot widget for userboarding slides
class SliderDot extends StatelessWidget {
  final int positionIndex, currentIndex;
  const SliderDot({this.currentIndex, this.positionIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 12,
      width: 12,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color:
              positionIndex == currentIndex ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(100)),
    );
  }
}
