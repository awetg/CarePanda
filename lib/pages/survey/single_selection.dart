import 'package:flutter/material.dart';

class RadioSingleSelection extends StatefulWidget {
  final List<String> _options;
  const RadioSingleSelection(this._options);
  @override
  _RadioSingleSelectionState createState() => _RadioSingleSelectionState();
}

class _RadioSingleSelectionState extends State<RadioSingleSelection> {
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
