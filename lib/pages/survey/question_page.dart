import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/survey/multi_selection.dart';
import 'package:carePanda/pages/survey/question_thankyou_page.dart';
import 'package:carePanda/pages/survey/single_selection.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final QuestionItem _questionItem;
  QuestionPage(this._questionItem);

  Widget getSelectionWidget() {
    if (_questionItem.type == QuestionType.RangeSelection)
      // Widget for RangeSelection or slider input is set to SingleSelection widget for now
      return RadioSingleSelection(List.generate(
          _questionItem.rangeMax.toInt(), (i) => (i + 1).toString()));
    else if (_questionItem.type == QuestionType.SingleSelection)
      return RadioSingleSelection(_questionItem.options);
    else
      return CheckBoxMultiSelection(_questionItem.options);
  }

  @override
  Widget build(BuildContext context) {
    return this._questionItem.id < 0
        ? ThankYouPage()
        : Container(
            margin: EdgeInsets.symmetric(vertical: 96, horizontal: 16),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      _questionItem.question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(children: [
                  Expanded(
                    // setting Single selection for Range selection type questions
                    child: getSelectionWidget(),
                  )
                ]),
                SizedBox(
                  height: 32.0,
                ),
                _questionItem.freeText
                    ? Form(
                        child: TextFormField(
                            maxLines: 3,
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText: "Optional free text")),
                      )
                    : Container()
              ],
            ),
          );
  }
}
