import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/main.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/survey/question_page.dart';
import 'package:carePanda/pages/survey/question_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SurveyFlow extends StatefulWidget {
  @override
  _SurveyFlowState createState() => _SurveyFlowState();
}

class _SurveyFlowState extends State<SurveyFlow> {
  // required property of the PageView
  PageController _pageController;
  // current index of page
  int currentIndex = 0;
  // duration of animation to change to next page
  static const animation_duration = const Duration(milliseconds: 300);
  // type of animation to change to next page
  static const animation_type = Curves.ease;

  // Slider items to be shown each slide page, containing image, heading and bodytext
  static const _questions = [
    QuestionItem(1, "How is your wellbeing today?", QuestionType.RangeSelection,
        5, [], true),
    QuestionItem(2, "How is your workload today?", QuestionType.RangeSelection,
        5, [], false),
    QuestionItem(3, "Do you feel you are making progress at your work?",
        QuestionType.SingleSelection, 0, ["yes", "No"], true),
    QuestionItem(-1, "", QuestionType.RangeSelection, 0, [], false)
  ];

  // handle next page of PageContorller
  nextPage() {
    if (currentIndex < (_questions.length - 1))
      _pageController.nextPage(
          duration: animation_duration, curve: animation_type);
    else
      // Pushes to home and removes history, which makes it unable to move back with back button
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyStatefulWidget()),
          (Route<dynamic> route) => false).then(
        (value) {
          setState(() {});
        },
      );
  }

  //  pop SurveyFlow page
  previousPage() {
    _pageController.previousPage(
        duration: animation_duration, curve: animation_type);
  }

  // initialize pageContorller
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // dispose pageContorller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // handle onchanged funtion of PageView widget
  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: onChangedFunction,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _questions.length,
          itemBuilder: (context, i) => QuestionPage(_questions[i]),
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.topCenter,
              margin: EdgeInsets.symmetric(vertical: 64, horizontal: 16),
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < _questions.length; i++)
                    QuestionProgressIndicator(
                        positionIndex: i, currentIndex: currentIndex)
                ],
              ),
            ),
          ],
        ),
        currentIndex == _questions.length - 1
            ? Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 96.0),
                        child: ElevatedButton(
                          onPressed: nextPage,
                          child: Text(getTranslated(context, "doneBtn")),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(128, 36),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              )),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 32.0),
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text("CONTACT HR"),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(128, 36),
                              side: currentIndex == 0
                                  ? null
                                  : BorderSide(
                                      color: Colors.blue,
                                      style: BorderStyle.solid),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              )),
                        )),
                  ),
                ],
              )
            : Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                        padding: EdgeInsets.only(right: 16.0, bottom: 32.0),
                        child: ElevatedButton(
                          onPressed: nextPage,
                          child: Text(getTranslated(context, "nextBtn")),
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(128, 36),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              )),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 16.0, bottom: 32.0),
                        child: OutlinedButton(
                          onPressed: currentIndex == 0 ? null : previousPage,
                          child: Text(getTranslated(context, "previousBtn")),
                          style: OutlinedButton.styleFrom(
                              minimumSize: Size(128, 36),
                              side: currentIndex == 0
                                  ? null
                                  : BorderSide(
                                      color: Colors.blue,
                                      style: BorderStyle.solid),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                              )),
                        )),
                  ),
                ],
              )
      ]),
    );
  }
}
