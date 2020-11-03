import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:carePanda/ServiceLocator.dart';
import 'package:flutter/services.dart';

class UserDataPopup extends StatefulWidget {
  @override
  _UserDataPopup createState() => _UserDataPopup();
}

class _UserDataPopup extends State<UserDataPopup> {
  final _storageService = locator<LocalStorageService>();
  final _blueColor = Color(0xff027DC5);
  var _name;
  var _lastName;
  var _birthday;
  var _gender;
  var _building;

  @override
  void initState() {
    super.initState();
    _name = _storageService.name ?? "";
    _lastName = _storageService.lastName ?? "";
    _birthday = _storageService.birthday;
    _gender = _storageService.gender ?? "Don't want to tell";
    _building = _storageService.building ?? "Don't want to tell";
  }

  // Sets data to shared preferences
  setData() {
    // DEV USER DATA LOG
    /*
    log("set name: " + _name.toString());
    log("set last name: " + _lastName.toString());
    log("set age: " + _birthday.toString());
    log("set gender: " + _gender.toString());
    log("set building: " + _building.toString());
    */
    _storageService.name = _name;
    _storageService.lastName = _lastName;
    _storageService.birthday = _birthday.toString();
    _storageService.gender = _gender;
    _storageService.building = _building;
    _storageService.firstTimeStartUp = false;
    Navigator.of(context).pop();
  }

  // Formats date to show in UI, if no date is chosen previously, shows "no date chosen" message
  _dateFormatter(date) {
    if (date == null) {
      return "No date chosen";
    } else {
      // Parses date because birthday set to shared preference is saved as String
      var parsedDate = DateTime.parse(date.toString());
      var formattedDate =
          "${parsedDate.day}-${parsedDate.month}-${parsedDate.year}";
      return formattedDate;
    }
  }

  // Date time picker
  _selectDate(BuildContext context) async {
    // Start date of date time picker
    var _startDate;

    if (_birthday == null) {
      _startDate = DateTime.parse("2000-01-01 00:00:00");
    } else {
      // Parses date because birthday set to shared preference is saved as String
      _startDate = DateTime.parse(_birthday.toString());
    }

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != _birthday)
      setState(() {
        _birthday = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Please give us some info about yourself",
          style: TextStyle(color: _blueColor)),
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
                    child: TextFormField(
                      onChanged: (name) {
                        _name = name;
                      },
                      decoration: new InputDecoration(
                        labelText: "Name",
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      initialValue: _name,
                    ),
                  ),
                ),

                // Last name
                Expanded(
                  child: TextFormField(
                    onChanged: (lastName) {
                      _lastName = lastName;
                    },
                    decoration: new InputDecoration(
                      labelText: "Last name",
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                    initialValue: _lastName,
                  ),
                )
              ],
            ),
            SizedBox(height: 14),

            // Age
            Row(children: [
              Expanded(
                child: Text(
                  "Age",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              OutlineButton(
                onPressed: () => _selectDate(context),
                child: Text(_dateFormatter(_birthday)),
                textColor: _blueColor,
                splashColor: Color(0xffD7E0EB),
                borderSide: BorderSide(
                  color: _blueColor,
                ),
              )
            ]),
            // Choosing age via keyboard (numbers only) (OPTION 2)
            /*
            TextField(
              onChanged: (newAge) {
                _age = newAge;
              },
              decoration: new InputDecoration(
                labelText: "Age",
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),*/
            SizedBox(height: 4),

            // Gender
            Row(children: [
              Expanded(
                child: Text(
                  "Gender",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              SizedBox(width: 80),
              DropdownButton(
                value: _gender,
                underline: Container(
                  height: 1,
                  color: Colors.grey,
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
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              DropdownButton(
                value: _building,
                underline: Container(
                  height: 1,
                  color: Colors.grey,
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
                    _building = newValue;
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
                    style: TextStyle(fontSize: 13.0, color: _blueColor)),
              ],
            )
          ],
        ),
      ),

      // Skip and submit buttons
      actions: [
        FlatButton(
          child: const Text('Skip', style: TextStyle(fontSize: 18)),
          textColor: _blueColor,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        RaisedButton(
          child: const Text('Submit', style: TextStyle(fontSize: 18)),
          color: _blueColor,
          textColor: Colors.white,
          splashColor: Color(0xffD7E0EB),
          onPressed: () {
            setData();
          },
        ),
      ],
    );
  }
}
