import 'dart:convert';

import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/main.dart';
import 'package:carePanda/model/building.dart';
import 'package:carePanda/model/user_data.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/widgets/UserDataDropDownButton.dart';
import 'package:carePanda/widgets/UserDataPickerPopup.dart';
import 'package:carePanda/widgets/UserDataTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/services/ServiceLocator.dart';

class UserDataPopup extends StatefulWidget {
  final bool firstStartUp;
  const UserDataPopup({this.firstStartUp = false});
  @override
  _UserDataPopup createState() => _UserDataPopup();
}

class _UserDataPopup extends State<UserDataPopup> {
  final _storageService = locator<LocalStorageService>();
  final _formKey = GlobalKey<FormState>();
  UserData _userData;
  bool _showFloors = false;

  @override
  void initState() {
    String prevData = _storageService.userData;
    _userData =
        prevData != null ? UserData.fromMap(json.decode(prevData)) : UserData();
    _showFloors = int.parse(_userData.building) > 0;
    super.initState();
  }

  // build floors as a list
  List<String> getFloors(int floors) {
    var list = new List<String>.generate(floors, (i) => (i + 1).toString());
    list.insert(0, getTranslated(context, "userData_dontWnaTell"));
    return list;
  }

  // Skips setting data but but changes shared preference so that the popup wont show up when opening app again
  exitPopUp() {
    if (widget.firstStartUp) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AppNavigation()),
          (Route<dynamic> route) => false).then(
        (value) {
          setState(() {});
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // list of genders
    Map<String, String> _genderList = {
      "-1": getTranslated(context, "userData_dontWnaTell"),
      "0": getTranslated(context, "userData_male"),
      "1": getTranslated(context, "userData_female"),
      "2": getTranslated(context, "userData_other")
    };

    // list of available options for building or workplace
    Map<String, Building> _buildingList = {
      "-1": Building(
          name: getTranslated(context, "userData_dontWnaTell"), floors: -1),
      "0": Building(
          name: getTranslated(context, "userData_workFromHome"), floors: -1),
      "1": Building(name: "Karaportti 4", floors: 6),
      "2": Building(name: "Karaportti 8", floors: 2),
      "3": Building(name: "KaraEast (Building 12)", floors: 5),
      "4": Building(name: "Mid Point 7A", floors: 8),
      "5": Building(name: "Mid Point 7B", floors: 6),
      "6": Building(name: "Mid Point 7C", floors: 5)
    };

    // set cancel button
    String _cancelPopupText = widget.firstStartUp
        ? getTranslated(context, "skipBtn")
        : getTranslated(context, "cancelBtn");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !widget.firstStartUp,
        title: Text(getTranslated(context, 'userData_title'),
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 18, top: 12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    // TextField Name
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 15,
                          top: 16,
                        ),
                        child: UserDataTextField(
                          label:
                              getTranslated(context, "userData_nameTxtfield"),
                          value: _userData.name,
                          onChange: (newValue) {
                            _userData.name = newValue;
                          },
                        ),
                      ),
                    ),

                    // TextField Last name
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: UserDataTextField(
                          label: getTranslated(
                              context, "userData_lastNameTxtfield"),
                          value: _userData.lastName,
                          onChange: (newValue) {
                            _userData.lastName = newValue;
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
                      setState(() {
                        _userData.birthYear = "-1";
                      });
                    },
                  ),

                  SizedBox(width: 4),

                  // Set age
                  OutlineButton(
                    onPressed: () async {
                      String value = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UserDataPickerPopup(
                              title:
                                  getTranslated(context, "userData_birthYear"),
                              data: [
                                for (int i = 1940; i < 2020; i += 1)
                                  i.toString()
                              ],
                              value: _userData.birthYear == "-1"
                                  ? "1990"
                                  : _userData.birthYear,
                            );
                          });
                      // setting value returned from ShowDialog
                      setState(() {
                        if (value != null) {
                          _userData.birthYear = value;
                        }
                      });
                    },
                    child: Text(
                        _userData.birthYear == "-1"
                            ? getTranslated(context, "userData_notSelected")
                            : _userData.birthYear,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
                    textColor: Theme.of(context).accentColor,
                    borderSide: BorderSide(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ]),

                SizedBox(height: 10),

                // Years Worked
                Row(children: [
                  Expanded(
                    child: Text(getTranslated(context, "userData_yearsInNokia"),
                        style: TextStyle(fontSize: 18)),
                  ),

                  // Reset years worked
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
                      setState(() {
                        _userData.yearsWorked = "-1";
                      });
                    },
                  ),

                  SizedBox(width: 4),

                  // Set years worked
                  OutlineButton(
                    onPressed: () async {
                      String value = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return UserDataPickerPopup(
                              title: getTranslated(
                                  context, "userData_yearsInNokia"),
                              data: [
                                for (int i = 0; i < 80; i += 1) i.toString()
                              ],
                              value: _userData.yearsWorked == "-1"
                                  ? "0"
                                  : _userData.yearsWorked,
                            );
                          });
                      setState(() {
                        if (value != null) {
                          _userData.yearsWorked = value;
                        }
                      });
                    },
                    child: Text(
                        _userData.yearsWorked == "-1"
                            ? getTranslated(context, "userData_notSelected")
                            : _userData.yearsWorked,
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyText1.color)),
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
                    value: _genderList[_userData.gender],
                    data: _genderList.values,
                    onChange: (newValue) {
                      setState(() {
                        _userData.gender = _genderList.keys.firstWhere(
                                (k) => _genderList[k] == newValue,
                                orElse: null) ??
                            "-1";
                      });
                    }),

                SizedBox(height: 22),

                // Work building
                UserDataDropDownButton(
                    settingName:
                        getTranslated(context, "userData_workBuilding"),
                    settingNameFontSize: 18.0,
                    value: _buildingList[_userData.building].name,
                    data: _buildingList.values.map((e) => e.name),
                    onChange: (newValue) {
                      setState(() {
                        _userData.building = _buildingList.keys.firstWhere(
                                (k) => _buildingList[k].name == newValue,
                                orElse: null) ??
                            "-1";
                        print("Building: ${_userData.building}");
                        _showFloors = int.parse(_userData.building) > 0;
                      });
                    }),

                SizedBox(height: 22),

                // Floor
                if (_showFloors)
                  UserDataDropDownButton(
                      settingName: getTranslated(context, "userData_floor"),
                      settingNameFontSize: 18.0,
                      value: _userData.floor == "-1"
                          ? getTranslated(context, "userData_dontWnaTell")
                          : _userData.floor,
                      data: getFloors(_buildingList[_userData.building].floors),
                      onChange: (newValue) {
                        setState(() {
                          _userData.floor = newValue;
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
                          getTranslated(
                              context, "userData_personalInfoOptional"),
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
                    if (widget.firstStartUp)
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

                // Submit buton
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(getTranslated(context, "submitBtn"),
                        style: TextStyle(fontSize: 18)),
                    textColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _storageService.userData =
                            json.encode(_userData.toMap());
                        exitPopUp();
                      } else {
                        print("Form not validate");
                        // handle error
                      }
                    },
                  ),
                ),
                // skip/cancel button
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child:
                        Text(_cancelPopupText, style: TextStyle(fontSize: 18)),
                    textColor: Theme.of(context).accentColor,
                    onPressed: exitPopUp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
