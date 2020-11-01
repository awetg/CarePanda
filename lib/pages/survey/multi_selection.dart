import 'package:flutter/material.dart';

class CheckBoxMultiSelection extends StatefulWidget {
  final List<String> _options;
  const CheckBoxMultiSelection(this._options);
  @override
  _CheckBoxMultiSelectionState createState() => _CheckBoxMultiSelectionState();
}

class _CheckBoxMultiSelectionState extends State<CheckBoxMultiSelection> {
  String _radioValue = "";

  void handleRadioValueChanged(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        for (int i = 0; i < this.widget._options.length; ++i)
          RadioListTile(
            title: Text(this.widget._options[i]),
            value: this.widget._options[i],
            groupValue: _radioValue,
            onChanged: handleRadioValueChanged,
          )
      ]),
    );
  }
}
