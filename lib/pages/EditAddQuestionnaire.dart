import 'dart:convert';
import 'package:carePanda/DataStructures/QuestionnaireAddDataStructure.dart';
import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/widgets/SimplePopupTwoButtons.dart';
import 'package:carePanda/widgets/UserDataDropDownButton.dart';
import 'package:carePanda/widgets/UserDataTextField.dart';
import 'package:flutter/material.dart';

class EditAddQuestionnaire extends StatefulWidget {
  EditAddQuestionnaire({
    @required this.pageTitle,
    this.questionnaireData,
  });

  final pageTitle;
  final questionnaireData;

  @override
  _EditAddQuestionnaireState createState() => _EditAddQuestionnaireState();
}

class _EditAddQuestionnaireState extends State<EditAddQuestionnaire> {
  // List of question types
  var _questionTypeList;

  // Amount of options for multi selection questionnaire
  final _optionAmountList = ["2", "3", "4", "5"];

  // Questionnaire variables
  var _questionText;
  var _freeTextBoxBool;
  var _questionType;
  var _questionTypeIndex;
  var _optionAmount;
  var _listOfOptions;

  // Bool to show or hide delete button
  var _newQuestionnaire = true;

  // New questionnaire list that is returned
  var newQuestionList;

  // Text field controller so that resetting textfield's is possible
  var textFieldController = TextEditingController();

  // List of new options
  var newListOfOptions = [];

  @override
  void didChangeDependencies() {
    _questionTypeList = [
      getTranslated(context, "hr_rangeSelection"),
      getTranslated(context, "hr_singleSelection"),
      getTranslated(context, "hr_multiSelection"),
    ];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // Question text
    // If question text is free, it means user is adding new questionnaire. Doesn's show delete button for adding new questionnaire
    if (widget.questionnaireData.question == null) {
      _newQuestionnaire = false;
    }
    _questionText = widget.questionnaireData.question ?? "";

    // Free text box boolean
    _freeTextBoxBool = widget.questionnaireData.freeText ?? true;

    // Question type, repalcing characters to make it prettier for user
    if (widget.questionnaireData.questionType == null) {
      _questionType = "QuestionType.RangeSelection";
      _questionTypeToIndex(_questionType);
    } else {
      _questionType = widget.questionnaireData.questionType;
      _questionTypeToIndex(_questionType);
    }
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

  // Gets index of question type to use the translated value in the dropdown menu
  _questionTypeToIndex(qstType) {
    switch (qstType) {
      case "QuestionType.RangeSelection":
        _questionTypeIndex = 0;
        break;
      case "QuestionType.SingleSelection":
        _questionTypeIndex = 1;
        break;
      case "QuestionType.MultiSelection":
        _questionTypeIndex = 2;
        break;
      default:
        _questionTypeIndex = 0;
        break;
    }
  }

  // Changes question type's index back to value so it can be stored in firestore properly
  _questionTypeIndexToString(qstTypeIndex) {
    switch (qstTypeIndex) {
      case 0:
        return "QuestionType.RangeSelection";
      case 1:
        return "QuestionType.SingleSelection";
      case 2:
        return "QuestionType.MultiSelection";
      default:
        return "QuestionType.RangeSelection";
    }
  }

  // Changes the questionnaire type
  _questionTypeOnChange(newValue) {
    setState(() {
      _optionAmount = "2";
      _questionTypeIndex = _questionTypeList.indexOf(newValue);
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
  _submitQuestionnaire(context) {
    var _questionTextNotEmpty = true;
    var _optionNotEmpty = true;

    // Removes spaces from question text and check's if it's empty
    if (_questionText.replaceAll(new RegExp(r"\s+"), "") == "") {
      _questionTextNotEmpty = false;
    }

    var _lengthDifference = int.parse(_optionAmount) - _listOfOptions.length;

    if (_questionTypeIndex == 1 || _questionTypeIndex == 2) {
      if (_lengthDifference == 0) {
        // If length difference is 0, we can go through the option list and check if there is empty spot
        for (var i = 0; i < int.parse(_optionAmount); i++) {
          if (_listOfOptions[i] == "") {
            _optionNotEmpty = false;
          }
        }
        // If lenght it different, it means there is atlest 1 empty space
      } else {
        _optionNotEmpty = false;
      }
    }

    // Edits data to how it will be saved (not sure if needed)
    // Uses the data structure to get into right form
    newQuestionList = new QuestionnaireAddDataStructure(
        _freeTextBoxBool,
        _questionText.toString(),
        _questionTypeIndexToString(_questionTypeIndex),
        _listOfOptions
            .toString()
            .replaceAll("[", '["')
            .replaceAll("]", '"]')
            .replaceAll(", ", '","'),
        10);

    var arrayToParent = [];

    // Array with variable submit so that parent knows wheter to delete or submit
    arrayToParent.add(newQuestionList);
    arrayToParent.add("Submit");

    // Navigates back to HR management and removes history so going back is not possible
    // If option or question text is empty, shows snackbar and doesn't submit
    if (_questionTextNotEmpty) {
      if (_optionNotEmpty) {
        Navigator.pop(context, arrayToParent);
      } else {
        _createSnackBar(
            getTranslated(context, "hr_editSnackbarOptionEmpty"), context);
      }
    } else {
      _createSnackBar(
          getTranslated(context, "hr_editSnackbarQuestEmpty"), context);
    }
  }

  _deleteQuestionnaire() async {
    // Sends String "Delete" to parent so it knows to delete the questionnaire
    var variableForParent = "Delete";

    // Opens dialog to make sure user wants to delete questionnaire
    // Also prevents user from acidentally deleting questionnaire
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimplePopUp(
            cancelBtnName: getTranslated(context, "cancelBtn"),
            confirmBtnName: getTranslated(context, "confirmBtn"),
            title: getTranslated(context, "hr_deletePopupTitle"),
          );
        });
    if (result ?? false) {
      Navigator.pop(context, variableForParent);
    }
  }

  // Creates snackbar to show error messages
  _createSnackBar(String message, dcontext) {
    final snackBar = new SnackBar(
        content: new Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).errorColor);

    Scaffold.of(dcontext).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pageTitle,
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      // Scroll view
      body: Builder(
        builder: (ctx) => SingleChildScrollView(
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
                          child: Text(getTranslated(context, "hr_editQuestion"),
                              style: TextStyle(fontSize: 20))),
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
                                hintText: getTranslated(
                                    context, "hr_editQuestonHint")),
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
                  SizedBox(height: 12),

                  // Free text answer box

                  ListTileTheme(
                    contentPadding: EdgeInsets.all(0),
                    child: CheckboxListTile(
                      title: Text(getTranslated(context, "hr_editFreeTextBox"),
                          style: TextStyle(fontSize: 20)),
                      value: _freeTextBoxBool,
                      activeColor: Theme.of(context).accentColor,
                      onChanged: (newValue) {
                        setState(() {
                          _freeTextBoxBool = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),

                  SizedBox(height: 12),

                  // Question type
                  UserDataDropDownButton(
                      settingName:
                          getTranslated(context, "hr_editQuestionType"),
                      data: _questionTypeList,
                      value: _questionTypeList[_questionTypeIndex],
                      settingNameFontSize: 18.00,
                      onChange: (newValue) {
                        _questionTypeOnChange(newValue);
                      }),

                  // Free space
                  SizedBox(height: 22),

                  // Options for ranged/single -selection
                  if (_questionTypeIndex == 1 || _questionTypeIndex == 2)
                    UserDataDropDownButton(
                        settingName:
                            getTranslated(context, "hr_editOptionsAmount"),
                        data: _optionAmountList,
                        value: _optionAmount.toString(),
                        settingNameFontSize: 18.00,
                        onChange: (newValue) {
                          _optionAmountOnChange(newValue);
                        }),

                  // Free space
                  if (_questionTypeIndex == 2) SizedBox(height: 4),

                  // Multi selection
                  if (_questionTypeIndex == 2)
                    TextFieldGenerator(
                        amount: int.parse(_optionAmount),
                        listOfOptions: _listOfOptions,
                        controller: textFieldController,
                        returnListFunction: (value, i) {
                          _optionOnChange(value, i);
                        }),

                  // Single selection
                  if (_questionTypeIndex == 1)
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
                        child: Text(getTranslated(context, "submitBtn"),
                            style: TextStyle(fontSize: 18)),
                        textColor: Colors.white,
                        onPressed: () {
                          _submitQuestionnaire(ctx);
                        },
                      ),
                    ),
                  ),

                  // Delete button
                  if (_newQuestionnaire)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          child: Text(getTranslated(context, "deleteBtn"),
                              style: TextStyle(fontSize: 18)),
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            _deleteQuestionnaire();
                          },
                        ),
                      ),
                    ),
                ],
              ),
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
              child: Text(
                  '${getTranslated(context, "hr_editOption")} ${(i + 1).toString()}',
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
                    label: "${getTranslated(context, "hr_editOption")} " +
                        (i + 1).toString(),
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
