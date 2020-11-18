import 'package:carePanda/localization/localization.dart';
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

  var _genderList;
  var _buildingList;

  // Takes in building's index to know how many floor is there in the building
  // This list is later used to create a list of floors depending on this list's values
  final floorAmountPerBuilding = [6, 2, 5, 8, 6, 5];
  var floorList;

  @override
  void initState() {
    if (_storageService.firstTimeStartUp ?? true) {
      _setUpVariables();
    }
    super.initState();
  }

  // Sets up variables to default values on first start up
  _setUpVariables() {
    _storageService.name = "";
    _storageService.lastName = "";
    _storageService.birthYear = 0;
    _storageService.yearsInNokia = 0;
    _storageService.gender = 0;
    _storageService.building = 0;
    _storageService.floor = 0;
  }

  // Initialises variables and gives them default values if they are null
  // If int variables are set to 0, set's variable to "Not selected" or Don't want to tell" to display it instead of 0
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _genderList = [
      getTranslated(context, "userData_dontWnaTell"),
      getTranslated(context, "userData_male"),
      getTranslated(context, "userData_female"),
      getTranslated(context, "userData_other")
    ];

    _buildingList = [
      getTranslated(context, "userData_dontWnaTell"),
      getTranslated(context, "userData_workFromHome"),
      "Karaportti 4",
      "Karaportti 8",
      "KaraEast (Building 12)",
      "Mid Point 7A",
      "Mid Point 7B",
      "Mid Point 7C"
    ];

    _name = _storageService.name;
    _lastName = _storageService.lastName;

    // Birth year and years worked in nokia, if 0, sets it to not selected
    _birthYear = _storageService.birthYear;
    if (_birthYear == 0) {
      _birthYear = getTranslated(context, "userData_notSelected");
    }

    _yearsInNokia = _storageService.yearsInNokia;
    if (_yearsInNokia == 0) {
      _yearsInNokia = getTranslated(context, "userData_notSelected");
    }

    // Gender and building uses lists index to identify which the user has chosen
    // Index is stored in shared preference and this way localization is easier.
    _gender = _genderList[_storageService.gender];

    _building = _buildingList[_storageService.building];

    // Gets floors data from shared preference, if it's 0, sets it to "Don't want to tell"
    _floor = _storageService.floor.toString();
    if (_floor == "0") {
      _floor = getTranslated(context, "userData_dontWnaTell");
    }

    // If building value is chosen by the user, generates floorlist depending on floorAmountPerBuilding values using building list's index
    if (_buildingList.indexOf(_building) != 0 &&
        _buildingList.indexOf(_building) != 1) {
      floorList = [
        for (var i = 1;
            i <
                floorAmountPerBuilding[_buildingList.indexOf(_building) - 2] +
                    1;
            i += 1)
          i.toString()
      ];
      floorList.insert(0, getTranslated(context, "userData_dontWnaTell"));
    }

    _firstTimeStartUp = _storageService.firstTimeStartUp ?? true;

    // If popup is opened from settings, shows different button text
    if (_firstTimeStartUp == true || _firstTimeStartUp == null) {
      _cancelPopupText = getTranslated(context, "skipBtn");
    } else {
      _cancelPopupText = getTranslated(context, "cancelBtn");
    }
  }

  // Sets data to shared preferences
  setData() {
    // If no years selected, defaults it to 0 since they have to be int
    if (_yearsInNokia == getTranslated(context, "userData_notSelected")) {
      _yearsInNokia = 0;
    }
    if (_birthYear == getTranslated(context, "userData_notSelected")) {
      _birthYear = 0;
    }

    // Sets data to shared preference
    _storageService.name = _name;
    _storageService.lastName = _lastName;
    _storageService.birthYear = _birthYear;
    _storageService.yearsInNokia = _yearsInNokia;
    _storageService.gender = _genderList.indexOf(_gender);
    _storageService.building = _buildingList.indexOf(_building);

    // If user doesn't give building data, sets floor data to "Don't wan't to tell" aswell
    if (_buildingList.indexOf(_building) == 0) {
      _floor = getTranslated(context, "userData_dontWnaTell");
    }

    // If user don't want to give floor data, sets it to 0 (floor is stored as int)
    // If user gives floor data, parses the String to int
    if (_floor == getTranslated(context, "userData_dontWnaTell")) {
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
      _birthYear = getTranslated(context, "userData_notSelected");
    });
  }

  // Resets years in nokia variable from shared preferences
  _resetYearsInNokia() {
    setState(() {
      _storageService.yearsInNokia = 0;
      _yearsInNokia = getTranslated(context, "userData_notSelected");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            _storageService.firstTimeStartUp ?? true ? false : true,
        title: Text(getTranslated(context, 'userData_title'),
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 18, top: 12),
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
                        label: getTranslated(context, "userData_nameTxtfield"),
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
                        label:
                            getTranslated(context, "userData_lastNameTxtfield"),
                        value: _lastName,
                        onChange: (newValue) {
                          _lastName = newValue;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22),

              // Age
              Row(children: [
                Expanded(
                  child: Text(getTranslated(context, "userData_birthYear"),
                      style: TextStyle(fontSize: 18)),
                ),

                // Reset age

                OutlineButton(
                  child: Text(
                    getTranslated(context, "userData_reset"),
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
                              title:
                                  getTranslated(context, "userData_birthYear"),
                              valueToChange: "birthYear",
                              value: _birthYear);
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

              SizedBox(height: 10),

              // Years in Nokia
              Row(children: [
                Expanded(
                  child: Text(getTranslated(context, "userData_yearsInNokia"),
                      style: TextStyle(fontSize: 18)),
                ),

                // Reset years in Nokia
                OutlineButton(
                  child: Text(
                    getTranslated(context, "userData_reset"),
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
                            title:
                                getTranslated(context, "userData_yearsInNokia"),
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

              SizedBox(height: 14),

              // Gender
              UserDataDropDownButton(
                  settingName: getTranslated(context, "userData_gender"),
                  settingNameFontSize: 18.0,
                  value: _gender,
                  data: _genderList,
                  onChange: (newValue) {
                    setState(() {
                      _gender = newValue;
                    });
                  }),

              SizedBox(height: 22),

              // Work building
              UserDataDropDownButton(
                  settingName: getTranslated(context, "userData_workBuilding"),
                  settingNameFontSize: 18.0,
                  value: _building,
                  data: _buildingList,
                  onChange: (newValue) {
                    setState(() {
                      // If value changes, changes floor to basic value, changes floor's list depending on building value
                      if (newValue != _building) {
                        _building = newValue;
                        _floor = getTranslated(context, "userData_dontWnaTell");
                        if (_buildingList.indexOf(_building) != 0 &&
                            _buildingList.indexOf(_building) != 1) {
                          // Creates floor list depending on building's index value
                          floorList = [
                            for (var i = 1;
                                i <
                                    floorAmountPerBuilding[
                                            _buildingList.indexOf(_building) -
                                                2] +
                                        1;
                                i += 1)
                              i.toString()
                          ];
                          floorList.insert(0,
                              getTranslated(context, "userData_dontWnaTell"));
                        }
                      }
                    });
                  }),

              SizedBox(height: 22),

              // Floor
              if (_buildingList.indexOf(_building) != 0 &&
                  _buildingList.indexOf(_building) != 1)
                UserDataDropDownButton(
                    settingName: getTranslated(context, "userData_floor"),
                    settingNameFontSize: 18.0,
                    value: _floor,
                    data: floorList,
                    onChange: (newValue) {
                      setState(() {
                        _floor = newValue;
                      });
                    }),
              SizedBox(height: 20),

              // Text to show that giving data is optional
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                        getTranslated(context, "userData_personalInfoOptional"),
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).accentColor)),
                  ),
                ],
              ),
              // Text to inform user that data can be changed later on in settings (only shows the message on first launch)
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_firstTimeStartUp == true || _firstTimeStartUp == null)
                    Flexible(
                      child: Text(
                          getTranslated(
                              context, "userData_personalChangedInSettings"),
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Theme.of(context).accentColor)),
                    ),
                ],
              ),

              SizedBox(height: 10),

              // Submit and skip buttons
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  child: Text(getTranslated(context, "submitBtn"),
                      style: TextStyle(fontSize: 18)),
                  textColor: Colors.white,
                  onPressed: () {
                    setData();
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  child: Text(_cancelPopupText, style: TextStyle(fontSize: 18)),
                  textColor: Theme.of(context).accentColor,
                  onPressed: () {
                    skipSettingData();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
