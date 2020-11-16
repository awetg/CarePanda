import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/widgets/UserDataDropDownButton.dart';
import 'package:carePanda/widgets/UserDataPickerPopup.dart';
import 'package:carePanda/widgets/UserDataTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/services/ServiceLocator.dart';

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

  final buildingData = [
    "Don't want to tell",
    "Working from home",
    "Karaportti 8",
    "Mid Point 7A",
    "Mid Point 7B",
    "Mid Point 7C",
    "Karaportti 4",
    "KaraEast (Building 12)"
  ];

  // Takes in building's index to know how many floor is there in the building
  // This list is later used to create a list of floors depending on this list's values
  final floorAmountPerBuilding = [2, 8, 6, 5, 6, 5];
  var floorList;

  // Initialises variables and gives them default values if they are null
  // If int variables are set to 0, set's variable to "Not selected" or "Don't want to tell" to display it instead of 0
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
    _floor = _storageService.floor.toString() ?? "Don't want to tell";

    if (_floor == "0") {
      _floor = "Don't want to tell";
    }

    // If building value is chosen by the user, generates floorlist depending on floorAmountPerBuilding values using building list's index
    if (_building != "Don't want to tell" && _building != "Working from home") {
      floorList = [
        for (var i = 1;
            i < floorAmountPerBuilding[buildingData.indexOf(_building) - 2] + 1;
            i += 1)
          i.toString()
      ];
      floorList.insert(0, "Don't want to tell");
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
    // If no years selected, defaults it to 0 since they have to be int
    if (_yearsInNokia == "Not selected") {
      _yearsInNokia = 0;
    }
    if (_birthYear == "Not selected") {
      _birthYear = 0;
    }

    // Sets data to shared preference
    _storageService.name = _name;
    _storageService.lastName = _lastName;
    _storageService.birthYear = _birthYear;
    _storageService.yearsInNokia = _yearsInNokia;
    _storageService.gender = _gender;
    _storageService.building = _building;

    // If user doesn't give building data, sets floor data to "Don't wan't to tell" aswell
    if (_building == "Don't want to tell") {
      _floor = "Don't want to tell";
    }

    // If user don't want to give floor data, sets it to 0 (floor is stored as int)
    // If user gives floor data, parses the String to int
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

  // Resets birth year variable from shared preferences
  _resetBirthYear() {
    setState(() {
      _storageService.birthYear = 0;
      _birthYear = "Not selected";
    });
  }

  // Resets years in nokia variable from shared preferences
  _resetYearsInNokia() {
    setState(() {
      _storageService.yearsInNokia = 0;
      _yearsInNokia = "Not selected";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 14, right: 14),
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
                    padding: const EdgeInsets.only(
                      right: 15,
                      top: 16,
                    ),
                    child: UserDataTextField(
                      label: "Name",
                      value: _name,
                      onChange: (newValue) {
                        _name = newValue;
                      },
                    ),
                  ),
                ),

                // Last name
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: UserDataTextField(
                      label: "Last name",
                      value: _lastName,
                      onChange: (newValue) {
                        _lastName = newValue;
                      },
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
                        return UserDataPickerPopup(
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
                        return UserDataPickerPopup(
                          valueToChange: "yearsInNokia",
                          value: _yearsInNokia,
                        );
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

            SizedBox(height: 8),

            // Gender
            UserDataDropDownButton(
                settingName: "Gender",
                value: _gender,
                data: ["Don't want to tell", 'Male', 'Female', 'Other'],
                onChange: (newValue) {
                  setState(() {
                    _gender = newValue;
                  });
                }),

            SizedBox(height: 14),

            // Work building
            UserDataDropDownButton(
                settingName: "Work building",
                value: _building,
                data: buildingData,
                onChange: (newValue) {
                  setState(() {
                    // If value changes, changes floor to basic value, changes floor's list depending on building value
                    if (newValue != _building) {
                      _building = newValue;
                      _floor = "Don't want to tell";
                      if (_building != "Don't want to tell" &&
                          _building != "Working from home") {
                        // Creates floor list depending on building's index value
                        floorList = [
                          for (var i = 1;
                              i <
                                  floorAmountPerBuilding[
                                          buildingData.indexOf(_building) - 2] +
                                      1;
                              i += 1)
                            i.toString()
                        ];
                        floorList.insert(0, "Don't want to tell");
                      }
                    }
                  });
                }),

            SizedBox(height: 14),

            // Floor
            if (_building != "Don't want to tell" &&
                _building != "Working from home")
              UserDataDropDownButton(
                  settingName: "Floor",
                  value: _floor,
                  data: floorList,
                  onChange: (newValue) {
                    setState(() {
                      _floor = newValue;
                    });
                  }),
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
            // Text to inform user that data can be changed later on in settings (only shows the message on first launch)
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
