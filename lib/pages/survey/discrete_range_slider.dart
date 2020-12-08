import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';
import '../../services/ServiceLocator.dart';

// Slider input for question answering, the slider uses discrete values instead of continuous values
class DiscreteRangeSlider extends StatefulWidget {
  final double _sliderMaxRange;
  final String _questionId;
  const DiscreteRangeSlider(this._sliderMaxRange, this._questionId);
  @override
  _DiscreteRangeSliderState createState() => _DiscreteRangeSliderState();
}

class _DiscreteRangeSliderState extends State<DiscreteRangeSlider> {
  // value of slider widget
  double _discreteValue = 0;

  @override
  void initState() {
    /* set initial value of slider, initial value will only exist 
    only if user navigate to previously answered question in survery flow, that is before submitting the answers
    */
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
        // Row which includes slider and texts which include slider's min and max value
        Row(
          children: [
            Text(
              "0",
              style: TextStyle(fontSize: 18),
            ),
            Expanded(
              child: Slider(
                  value: _discreteValue,
                  min: 0,
                  max: widget._sliderMaxRange,
                  divisions: widget._sliderMaxRange.toInt(),
                  label: "$_discreteValue",
                  onChanged: (value) {
                    setState(() {
                      _discreteValue = value;
                    });
                    locator<SurveyResponseService>().updateResponseValue(
                        widget._questionId, value.toString());
                  }),
            ),
            Text("${widget._sliderMaxRange.toInt() ?? 5}",
                style: TextStyle(fontSize: 18)),
          ],
        )
      ],
    );
  }
}
