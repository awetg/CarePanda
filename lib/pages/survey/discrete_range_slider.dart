import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';
import '../../ServiceLocator.dart';

// Slider input for question answering, the slider uses discrete values instead of continuous values
class DiscreteRangeSlider extends StatefulWidget {
  final double _sliderMaxRange;
  final String _questionId;
  const DiscreteRangeSlider(this._sliderMaxRange, this._questionId);
  @override
  _DiscreteRangeSliderState createState() => _DiscreteRangeSliderState();
}

class _DiscreteRangeSliderState extends State<DiscreteRangeSlider> {
  double _discreteValue = 0;

  @override
  void initState() {
    String _initial = locator<SurveyResponseService>()
        .getResponseValueById(widget._questionId);
    try {
      _discreteValue = double.parse(_initial);
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Slider(
            value: _discreteValue,
            min: 0,
            max: widget._sliderMaxRange,
            divisions: widget._sliderMaxRange.toInt(),
            onChanged: (value) {
              setState(() {
                _discreteValue = value;
              });
              locator<SurveyResponseService>()
                  .updateResponseValue(widget._questionId, value.toString());
            })
      ],
    );
  }
}
