import 'dart:developer';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/widgets/PickerPopup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/ServiceLocator.dart';

class UserDataPopup extends StatefulWidget {
  @override
  _UserDataPopup createState() => _UserDataPopup();
}

class _UserDataPopup extends State<UserDataPopup> {
  final _storageService = locator<LocalStorageService>();
  var _name;
  var _lastName;
  var _birthYear;
  var _yearsInNokia;
  var _gender;
  var _building;
  var _floor;
  var _cancelPopupText;
  var _firstTimeStartUp;
  int _pickerDataBirthYear;
  int _pickerDataYearsInNokia;

  @override
  void initState() {
    super.initState();
    _name = _storageService.name ?? "";
    _lastName = _storageService.lastName ?? "";

    _birthYear = _storageService.birthYear ?? "Not selected";
    if (_birthYear == 0) {
      _birthYear = "Not selected";
    }

    _yearsInNokia = _storageService.yearsInNokia ?? "Not selected";
    if (_yearsInNokia == 0) {
      _yearsInNokia = "Not selected";
    }

    _gender = _storageService.gender ?? "Don't want to tell";
    _building = _storageService.building ?? "Don't want to tell";
    _floor = _storageService.floor ?? "Don't want to tell";
    log(_floor.toString());
    if (_floor == 0) {
      _floor = "Don't want to tell";
    }

    _firstTimeStartUp = _storageService.firstTimeStartUp ?? true;

    // If popup is opened from settings, shows different button text
    if (_firstTimeStartUp == true || _firstTimeStartUp == null) {
      _cancelPopupText = "Skip";
    } else {
      _cancelPopupText = "Cancel";
    }
  }

  // Sets data to shared preferences
  setData() {
    if (_yearsInNokia == "Not selected") {
      _yearsInNokia = 0;
    }
    if (_birthYear == "Not selected") {
      _birthYear = 0;
    }

    _storageService.name = _name;
    _storageService.lastName = _lastName;
    _storageService.birthYear = _birthYear;
    _storageService.yearsInNokia = _yearsInNokia;
    _storageService.gender = _gender;
    _storageService.building = _building;

    if (_building == "Don't want to tell") {
      _floor = "Don't want to tell";
    }

    if (_floor == "Don't want to tell") {
      _storageService.floor = 0;
    } else {
      _storageService.floor = int.parse(_floor);
    }

    _storageService.firstTimeStartUp = false;
    Navigator.of(context).pop();
  }

  // Skips setting data but but changes shared preference so that the popup wont show up when opening app again
  skipSettingData() {
    _storageService.firstTimeStartUp = false;
    Navigator.of(context).pop();
  }

  _resetBirthYear() {
    setState(() {
      _storageService.birthYear = 0;
      _birthYear = "Not selected";
    });
  }

  _resetYearsInNokia() {
    setState(() {
      _storageService.yearsInNokia = 0;
      _yearsInNokia = "Not selected";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Please give us some info about yourself",
          style: TextStyle(color: Theme.of(context).accentColor)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Name
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Color(0xff027DC5)),
                      child: TextFormField(
                        onChanged: (name) {
                          _name = name;
                        },
                        decoration: new InputDecoration(
                          labelText: "Name",
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                width: 1.5),
                          ),
                        ),
                        initialValue: _name,
                      ),
                    ),
                  ),
                ),

                // Last name
                Expanded(
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(primaryColor: Color(0xff027DC5)),
                    child: TextFormField(
                      onChanged: (lastName) {
                        _lastName = lastName;
                      },
                      decoration: new InputDecoration(
                        labelText: "Last name",
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              width: 1.5),
                        ),
                      ),
                      initialValue: _lastName,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),

            // Age
            Row(children: [
              Expanded(
                child: Text(
                  "Birth year",
                ),
              ),

              // Reset age
              Container(
                width: 68,
                child: OutlineButton(
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  textColor: Theme.of(context).accentColor,
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _resetBirthYear();
                  },
                ),
              ),

              SizedBox(width: 4),

              // Set age
              OutlineButton(
                onPressed: () async {
                  _pickerDataBirthYear = await showDialog(
                      barrierColor: _storageService.darkTheme
                          ? Colors.black.withOpacity(0.4)
                          : null,
                      context: context,
                      builder: (BuildContext context) {
                        return PickerPopup(
                            valueToChange: "birthYear", value: _birthYear);
                      });
                  setState(() {
                    if (_pickerDataBirthYear != null) {
                      _birthYear = _pickerDataBirthYear;
                    }
                  });
                },
                child: Text(_birthYear.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color)),
                textColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ]),
            SizedBox(height: 4),

            // Years in Nokia
            Row(children: [
              Expanded(
                child: Text(
                  "Years worked in Nokia",
                ),
              ),

              // Reset years in Nokia
              Container(
                width: 68,
                child: OutlineButton(
                  child: Text(
                    "Reset",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  textColor: Theme.of(context).accentColor,
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _resetYearsInNokia();
                  },
                ),
              ),

              SizedBox(width: 4),

              // Set years in Nokia
              OutlineButton(
                onPressed: () async {
                  _pickerDataYearsInNokia = await showDialog(
                      barrierColor: _storageService.darkTheme
                          ? Colors.black.withOpacity(0.4)
                          : null,
                      context: context,
                      builder: (BuildContext context) {
                        return PickerPopup(
                            valueToChange: "yearsInNokia",
                            value: _yearsInNokia);
                      });
                  setState(() {
                    if (_pickerDataYearsInNokia != null) {
                      _yearsInNokia = _pickerDataYearsInNokia;
                    }
                  });
                },
                child: Text(_yearsInNokia.toString(),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color)),
                textColor: Theme.of(context).accentColor,
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ]),

            SizedBox(height: 4),

            // Gender
            Row(children: [
              Expanded(
                child: Text(
                  "Gender",
                ),
              ),
              SizedBox(width: 80),
              DropdownButton(
                value: _gender,
                underline: Container(
                  height: 1,
                ),
                items: <String>["Don't want to tell", 'Male', 'Female', 'Other']
                    .map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                },
              ),
            ]),
            SizedBox(height: 0),

            // Work building
            Row(children: [
              Expanded(
                child: Text(
                  "Work building",
                ),
              ),
              DropdownButton(
                value: _building,
                underline: Container(
                  height: 1,
                ),
                items: <String>[
                  "Don't want to tell",
                  'Building 1',
                  'Building 2',
                  'Building 3'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _floor = "Don't want to tell";
                    _building = newValue;
                  });
                },
              ),
            ]),
            SizedBox(height: 8),

            // Floor
            if (_building != "Don't want to tell")
              Row(children: [
                Expanded(
                  child: Text(
                    "Floor",
                  ),
                ),
                DropdownButton(
                  value: _floor.toString(),
                  underline: Container(
                    height: 1,
                  ),
                  items: <String>["Don't want to tell", '1', '2', '3', '4', '5']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _floor = newValue;
                    });
                  },
                ),
              ]),
            SizedBox(height: 8),

            // Text to show that giving data is optional
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("* Giving personal data is optional",
                    style: TextStyle(
                        fontSize: 13.0, color: Theme.of(context).accentColor)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (_firstTimeStartUp == true || _firstTimeStartUp == null)
                  Text("* Personal data can be changed in settings",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Theme.of(context).accentColor)),
              ],
            )
          ],
        ),
      ),

      // Skip and submit buttons
      actions: [
        FlatButton(
          child: Text(_cancelPopupText, style: TextStyle(fontSize: 18)),
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            skipSettingData();
          },
        ),
        RaisedButton(
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
          onPressed: () {
            setData();
          },
        ),
      ],
    );
  }
}
