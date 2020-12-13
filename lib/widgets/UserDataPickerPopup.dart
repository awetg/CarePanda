import 'package:carePanda/localization/localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Picker popup used in userdata modifying
class UserDataPickerPopup extends StatelessWidget {
  final List<String> data;
  final String value;
  final String title;

  UserDataPickerPopup({this.data, this.value, this.title});
  @override
  Widget build(BuildContext context) {
    var _selectedItem = value;
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      title: Center(
          child: Text(title,
              style: TextStyle(color: Theme.of(context).accentColor))),
      content: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          // Picker
          child: CupertinoPicker(
              backgroundColor: Theme.of(context).cardColor,
              scrollController:
                  FixedExtentScrollController(initialItem: data.indexOf(value)),
              itemExtent: 50,
              magnification: 1.1,
              onSelectedItemChanged: (int index) {
                _selectedItem = data[index];
              },
              children: [
                for (String item in data)
                  Center(
                    child: Text(item,
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
          onPressed: () => Navigator.pop(context, _selectedItem),
        ),
      ],
    );
  }
}
