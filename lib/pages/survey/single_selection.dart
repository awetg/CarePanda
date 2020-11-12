import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';

class RadioSingleSelection extends StatefulWidget {
  final List<String> _options;
  final String _questionId;
  const RadioSingleSelection(this._options, this._questionId);
  @override
  _RadioSingleSelectionState createState() => _RadioSingleSelectionState();
}

class _RadioSingleSelectionState extends State<RadioSingleSelection> {
  String _radioValue = "";

  @override
  void initState() {
    _radioValue = locator<SurveyResponseService>()
        .getResponseValueById(widget._questionId);
    super.initState();
  }

  void handleRadioValueChanged(String value) {
    setState(() {
      _radioValue = value;
    });
    locator<SurveyResponseService>()
        .updateResponseValue(widget._questionId, value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        for (int i = 0; i < this.widget._options.length; ++i)
          RadioListTile(
            title: Text(widget._options[i]),
            value: this.widget._options[i],
            groupValue: _radioValue,
            onChanged: handleRadioValueChanged,
          )
      ]),
    );
  }
}
