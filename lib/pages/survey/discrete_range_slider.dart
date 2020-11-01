import 'package:flutter/material.dart';

class DiscreteRangeSlider extends StatefulWidget {
  final double _sliderMaxRange;
  const DiscreteRangeSlider(this._sliderMaxRange);
  @override
  _DiscreteRangeSliderState createState() => _DiscreteRangeSliderState();
}

class _DiscreteRangeSliderState extends State<DiscreteRangeSlider> {
  double _discreteValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
            value: _discreteValue,
            min: 0,
            max: this.widget._sliderMaxRange,
            divisions: 5,
            onChanged: (value) {
              setState(() {
                _discreteValue = value;
              });
            })
      ],
    );
  }
}
