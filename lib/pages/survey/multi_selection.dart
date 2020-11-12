import 'dart:convert';
import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';
import '../../services/ServiceLocator.dart';

class CheckBoxMultiSelection extends StatefulWidget {
  final List<String> _options;
  final String _questionId;
  const CheckBoxMultiSelection(this._options, this._questionId);
  @override
  _CheckBoxMultiSelectionState createState() => _CheckBoxMultiSelectionState();
}

class _CheckBoxMultiSelectionState extends State<CheckBoxMultiSelection> {
  // create a set of selected options from list of availabe options in the question
  Set<String> _selectedOptions = Set();

  @override
  void initState() {
    // set initially selected options if the question was answered previously
    String _selected = locator<SurveyResponseService>()
        .getResponseValueById(widget._questionId);
    if (_selected.isNotEmpty) {
      _selectedOptions = Set<String>.from(jsonDecode(_selected));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        for (int i = 0; i < widget._options.length; ++i)
          CheckboxListTile(
            title: Text(widget._options[i]),
            value: _selectedOptions.contains(widget._options[i]),
            onChanged: (bool selected) {
              setState(() {
                if (selected)
                  _selectedOptions.add(widget._options[i]);
                else
                  _selectedOptions.remove(widget._options[i]);
              });
              locator<SurveyResponseService>().updateResponseValue(
                  widget._questionId, jsonEncode(_selectedOptions.toList()));
            },
          )
      ]),
    );
  }
}
