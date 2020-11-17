import 'package:carePanda/localization/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserDataPickerPopup extends StatefulWidget {
  final valueToChange;
  final value;
  final title;

  UserDataPickerPopup({this.valueToChange, this.value, this.title});

  @override
  _UserDataPickerPopupState createState() => _UserDataPickerPopupState();
}

class _UserDataPickerPopupState extends State<UserDataPickerPopup> {
  var _yearList = [for (var i = 1940; i < 2020; i += 1) i];
  var _yearsInNokiaList = [for (var i = 0; i < 80; i += 1) i];
  var _list;
  var _initialItem;

  @override
  void initState() {
    if (widget.valueToChange == "birthYear") {
      _list = _yearList;
    } else {
      _list = _yearsInNokiaList;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Gets initial value for picker depending on which variable is the user changing (Birth year or years worked in nokia)
    // If there is no value set before for the years, sets initial value to 50 (will show 1990 in the picker)
    if (widget.valueToChange == "birthYear") {
      if (widget.value != null &&
          widget.value != getTranslated(context, "userData_notSelected")) {
        _initialItem = _list.indexOf(widget.value);
      } else {
        _initialItem = 50;
      }
    } else {
      if (widget.value != null &&
          widget.value != getTranslated(context, "userData_notSelected")) {
        _initialItem = _list.indexOf(widget.value);
      } else {
        _initialItem = 5;
      }
    }

    super.didChangeDependencies();
  }

  var _selectedYear;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      title: Center(
          child: Text(widget.title,
              style: TextStyle(color: Theme.of(context).accentColor))),
      content: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: CupertinoPicker(
              backgroundColor: Theme.of(context).cardColor,
              scrollController:
                  FixedExtentScrollController(initialItem: _initialItem),
              itemExtent: 50,
              magnification: 1.1,
              onSelectedItemChanged: (int index) {
                _selectedYear = _list[index];
              },
              children: [
                for (int number in _list)
                  Center(
                    child: Text(number.toString(),
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
                  ),
              ]),
        ),
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text(getTranslated(context, "cancelBtn"),
              style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: Text(getTranslated(context, "submitBtn"),
              style: TextStyle(fontSize: 18)),
          textColor: Colors.white,
          onPressed: () {
            // If user picks no value and presses submit, defaults to initial value
            if (_selectedYear == null) {
              _selectedYear = _list[_initialItem];
            }

            Navigator.pop(context, _selectedYear);
          },
        ),
      ],
    );
  }
}
