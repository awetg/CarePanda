import 'dart:convert';
import 'dart:developer';

import 'package:carePanda/pages/HRmanagementPage.dart';
import 'package:carePanda/widgets/UserDataDropDownButton.dart';
import 'package:carePanda/widgets/UserDataTextField.dart';
import 'package:flutter/material.dart';

class EditAddQuestionnaire extends StatefulWidget {
  EditAddQuestionnaire(
      {@required this.pageTitle,
      @required this.questionnaireData,
      @required this.callBackFunction});

  final pageTitle;
  final questionnaireData;
  final callBackFunction;

  @override
  _EditAddQuestionnaireState createState() => _EditAddQuestionnaireState();
}

class _EditAddQuestionnaireState extends State<EditAddQuestionnaire> {
  final questionTypeList = [
    "Range selection",
    "Single selection",
    "Multi selection"
  ];
  final _optionAmountList = ["2", "3", "4", "5"];

  var _questionText;
  var _questionType;
  var _optionAmount = "";
  var _listOfOptions;

  // Text field controller so that resetting textfield's is possible
  var textFieldController = TextEditingController();

  // List of new options
  var newListOfOptions = [];

  @override
  void initState() {
    // Question text
    _questionText = widget.questionnaireData.question ?? "";

    // Question type, repalcing characters to make it prettier for user
    _questionType = widget.questionnaireData.questionType
        .toString()
        .replaceAll("QuestionType.", "")
        .replaceAll("Selection", " selection");

    // Get's option amount for multi/single -selection questionnaire
    _optionAmount = widget.questionnaireData.options;
    if (_optionAmount != null) {
      _optionAmount = json.decode(_optionAmount).length.toString();
    } else {
      _optionAmount = "2";
    }

    // Gets options of multi/single -selection questionnaire
    _listOfOptions = widget.questionnaireData.options;
    if (_listOfOptions != null) {
      _listOfOptions = json.decode(_listOfOptions);
    } else {
      _listOfOptions = [];
    }

    super.initState();
  }

  // Changes the questionnaire type
  _questionTypeOnChange(newValue) {
    setState(() {
      _optionAmount = "2";
      _questionType = newValue;
      _listOfOptions = [];
    });
  }

  // Changes the amount of options
  _optionAmountOnChange(newValue) {
    setState(() {
      _optionAmount = newValue;
      _listOfOptions = [];
      textFieldController.clear();
    });
  }

  // Handles option text fields changing
  _optionOnChange(newValue, index) {
    log(index.toString() + " " + _listOfOptions.length.toString());

    // If no previous data, adds empty spaces on list so replacing will be possible
    if (_listOfOptions.length <= index || _listOfOptions.length == 0) {
      var amountOfSpaces = index - _listOfOptions.length;
      for (var i = 0; i < amountOfSpaces + 1; i++) {
        _listOfOptions.add("");
      }
    }
    _listOfOptions[index] = newValue;
  }

  // Submits the questionnaire
  _submitQuestionnaire() {
    log(_questionText.toString());
    log(_questionType.toString());
    log(_listOfOptions.toString());

    // Navigates back to HR management and removes history so going back is not possible
    /*Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HRmanagementPage()),
        (Route<dynamic> route) => false).then(
      (value) {
        setState(() {});
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle,
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      // Scroll view
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 14,
              top: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Question text
                    Expanded(
                        child:
                            Text("Question", style: TextStyle(fontSize: 20))),
                    // Question text textfield, uses theme so that onclick border has color
                    Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: Color(0xff027DC5)),
                      child: Container(
                        width: 240,
                        color: Theme.of(context).cardColor,
                        child: TextFormField(
                          initialValue: _questionText,
                          maxLines: 2,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color,
                                ),
                              ),
                              hintText: "Question text"),
                          onChanged: (value) {
                            setState(() {
                              _questionText = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Free space
                SizedBox(height: 40),

                // Question type
                UserDataDropDownButton(
                    settingName: "Question type",
                    data: questionTypeList,
                    value: _questionType,
                    settingNameFont: 18.00,
                    onChange: (newValue) {
                      _questionTypeOnChange(newValue);
                    }),

                // Free space
                SizedBox(height: 22),

                // Options for ranged/single -selection
                if (_questionType == "Multi selection")
                  UserDataDropDownButton(
                      settingName: "Options amount",
                      data: _optionAmountList,
                      value: _optionAmount.toString(),
                      settingNameFont: 18.00,
                      onChange: (newValue) {
                        _optionAmountOnChange(newValue);
                      }),

                if (_questionType == "Multi selection") SizedBox(height: 4),

                // Multi selection
                if (_questionType == "Multi selection")
                  TextFieldGenerator(
                      amount: int.parse(_optionAmount),
                      listOfOptions: _listOfOptions,
                      controller: textFieldController,
                      returnListFunction: (value, i) {
                        _optionOnChange(value, i);
                      }),

                // Single selection
                if (_questionType == "Single selection")
                  TextFieldGenerator(
                      amount: int.parse(_optionAmount),
                      listOfOptions: _listOfOptions,
                      controller: textFieldController,
                      returnListFunction: (value, i) {
                        _optionOnChange(value, i);
                      }),

                // Submit button
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      child:
                          const Text('Submit', style: TextStyle(fontSize: 18)),
                      textColor: Colors.white,
                      onPressed: () {
                        _submitQuestionnaire();
                      },
                    ),
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

class TextFieldGenerator extends StatefulWidget {
  final amount;
  final listOfOptions;
  final returnListFunction;
  final controller;
  TextFieldGenerator(
      {@required this.amount,
      this.listOfOptions,
      this.returnListFunction,
      this.controller});
  @override
  _TextFieldGeneratorState createState() => _TextFieldGeneratorState();
}

class _TextFieldGeneratorState extends State<TextFieldGenerator> {
  var newController;
  @override
  void initState() {
    newController = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      // Generates wanted amount of textfields
      for (var i = 0; i < widget.amount; i++)
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Row(children: [
            // Setting name
            Expanded(
              child: Text('Option ${(i + 1).toString()}',
                  style: TextStyle(fontSize: 18)),
            ),

            // Textfield
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: UserDataTextField(
                    controller: newController = TextEditingController(
                        // Text field's initial value comes from controller, if no initial value shows nothing
                        text: widget.listOfOptions.isNotEmpty
                            ? widget.listOfOptions[i]
                            : ""),
                    label: "Option " + (i + 1).toString(),
                    onChange: (value) {
                      // OnChange function uses widget's callback function to give data for parent where it is handled
                      widget.returnListFunction(value, i);
                    }),
              ),
            )
          ]),
        ),
    ]));
  }
}
