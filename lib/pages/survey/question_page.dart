import 'package:carePanda/ServiceLocator.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/survey/discrete_range_slider.dart';
import 'package:carePanda/pages/survey/multi_selection.dart';
import 'package:carePanda/pages/survey/question_thankyou_page.dart';
import 'package:carePanda/pages/survey/single_selection.dart';
import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';

class QuestionPage extends StatelessWidget {
  final QuestionItem _questionItem;
  QuestionPage(this._questionItem);

  Widget getSelectionWidget() {
    // range selection is a slide input with max value of rangeMax from question
    if (_questionItem.type == QuestionType.RangeSelection)
      return DiscreteRangeSlider(_questionItem.rangeMax, _questionItem.id);
    // Alternatively using Radio single selection instead fo slider input
    // return RadioSingleSelection(
    //     List.generate(
    //         _questionItem.rangeMax.toInt(), (i) => (i + 1).toString()),
    //     _questionItem.id);
    // single selestions is a list of radio selection inputs where only single options is allowed
    else if (_questionItem.type == QuestionType.SingleSelection)
      return RadioSingleSelection(_questionItem.options, _questionItem.id);
    else // last question type is Multi selection, which is a list of checkboxes where more than on selection is allowed
      return CheckBoxMultiSelection(_questionItem.options, _questionItem.id);
  }

  // TODO: Find other solutions fo adding Thankyou page at then end of survey
  /* implemented solution should possibly add the page as last page of the survey instead of
    separate page for better UI design reasons
  */

  @override
  Widget build(BuildContext context) {
    // if the question id is not equal to last instantiate response object
    if (_questionItem.id != "last")
      locator<SurveyResponseService>().initResponseForQuestion(_questionItem);

    return this._questionItem.id == "last"
        // show if the question is empty question with last as id value
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
                            initialValue: locator<SurveyResponseService>()
                                .getFreeTextById(_questionItem.id),
                            onChanged: (text) {
                              locator<SurveyResponseService>()
                                  .updateFreeText(_questionItem.id, text);
                            },
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
