import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/main.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/pages/survey/question_page.dart';
import 'package:carePanda/pages/survey/question_progress_indicator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/services/survey_response_service.dart';
import 'package:flutter/material.dart';

// TODO: Label on each side of slider
// TODO: userdata into survery answer

class SurveyFlow extends StatefulWidget {
  @override
  _SurveyFlowState createState() => _SurveyFlowState();
}

class _SurveyFlowState extends State<SurveyFlow> {
  // required property of the PageView
  PageController _pageController;
  // current index of page
  int currentIndex = 0;
  // last page index, received from firestore service in stream builder, list of questions items as stream
  int lastQusetionIndex = 0;
  // duration of animation to change to next page
  static const animation_duration = const Duration(milliseconds: 300);
  // type of animation to change to next page
  static const animation_type = Curves.ease;

  /* empty question added to list of questions retrieved from firebase firestore 
  to show thank you page in last page of PageViwer */
  QuestionItem _emptyQ = QuestionItem(
      id: "last",
      question: "",
      type: QuestionType.RangeSelection,
      rangeMax: 0,
      options: [],
      freeText: false);

  // a function for deciding if page controller should navigate to next page
  bool continueToNextPage() {
    if (currentIndex < (lastQusetionIndex - 1))
      return true;
    else if (locator<SurveyResponseService>().allQuestionsAnswered())
      return true;
    else
      return false;
  }

  // handle next page of PageContorller
  nextPage() {
    _pageController.nextPage(
        duration: animation_duration, curve: animation_type);
  }

  //  pop SurveyFlow page
  void previousPage() {
    _pageController.previousPage(
        duration: animation_duration, curve: animation_type);
  }

  // initialize pageContorller
  @override
  void initState() {
    super.initState();
    locator<SurveyResponseService>().clearResponseMap();
    _pageController = PageController();
  }

  // dispose pageContorller
  @override
  void dispose() {
    _pageController.dispose();
    locator<SurveyResponseService>().clearResponseMap();
    super.dispose();
  }

  // handle onchanged funtion of PageView widget
  void onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // submit response after all questions are answered
  void submitResponse() {
    locator<FirestoreService>().saveAllSurveyResponse(
        locator<SurveyResponseService>().getAllResponses());
    locator<LocalStorageService>().hasQuestionnaire = false;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyStatefulWidget()),
        (Route<dynamic> route) => false).then(
      (value) {
        setState(() {});
      },
    );
  }

  // builds alert dialog with title, content and postive and negative buttons
  Widget getAlertDialog(
      {String title,
      String content,
      String positiveButtonTitle,
      Function() postiveOnPressed,
      String negativeButtonTitle,
      Function() negativeOnPressed}) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: postiveOnPressed,
          child: new Text(positiveButtonTitle),
        ),
        new OutlinedButton(
          onPressed: negativeOnPressed,
          child: new Text(negativeButtonTitle),
        ),
      ],
    );
  }

  // shows an alert if there are unanswered questions
  Widget unansweredQuestionsAlert() {
    return getAlertDialog(
        title: getTranslated(context, "qst_unansweredQstTitle"),
        content: getTranslated(context, "qst_unansweredQstContent"),
        positiveButtonTitle: getTranslated(context, "qst_answerBtn"),
        postiveOnPressed: () {
          // naviagate to first question or page if user decide to answer question
          _pageController.jumpToPage(_pageController.initialPage);
          Navigator.of(context).pop(false);
        },
        negativeButtonTitle: getTranslated(context, "qst_exitSurveyBtn"),
        negativeOnPressed: () {
          // exit survery flow or answering questions if user decide to exit,
          // answered questions will not be submitted if all questions are not answered
          Navigator.of(context).pop(true);
          Navigator.of(context).pop(true);
        });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => getAlertDialog(
              title: getTranslated(context, "qst_cancelAnsweringTitle"),
              content: getTranslated(context, "qst_cancelAnsweringContent"),
              positiveButtonTitle: getTranslated(context, "qst_noBtn"),
              postiveOnPressed: () => Navigator.of(context).pop(false),
              negativeButtonTitle: getTranslated(context, "qst_yesBtn"),
              negativeOnPressed: () => Navigator.of(context).pop(true)),
        )) ??
        false; // return false if user clicked outside of Alert Dialog
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    //   statusBarIconBrightness: Brightness.dark,
    // ));
    return StreamBuilder<List<QuestionItem>>(
        stream: locator<FirestoreService>().getSurveyQuestions(),
        builder: (context, snapshot) {
          // if there is list more than zero question show survey flow pages
          if (snapshot.hasData && snapshot.data.length > 0) {
            lastQusetionIndex = snapshot.data.length;

            return WillPopScope(
              onWillPop: _onWillPop,
              child: Scaffold(
                resizeToAvoidBottomPadding: false,
                body: Stack(children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: onChangedFunction,
                    physics: NeverScrollableScrollPhysics(),
                    // adding empty question to list of questions to set last page as thank you page
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (context, i) => QuestionPage(
                        i == snapshot.data.length ? _emptyQ : snapshot.data[i]),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.topStart,
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.topCenter,
                        margin:
                            EdgeInsets.symmetric(vertical: 64, horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            // show same number of indicator as number pages
                            for (int i = 0; i <= snapshot.data.length; i++)
                              QuestionProgressIndicator(
                                  positionIndex: i, currentIndex: currentIndex)
                          ],
                        ),
                      ),
                    ],
                  ),
                  // if current index is the lastpage show done page
                  currentIndex == lastQusetionIndex
                      ? Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                  padding: EdgeInsets.only(bottom: 96.0),
                                  child: ElevatedButton(
                                    onPressed: submitResponse,
                                    child: Text(
                                        getTranslated(context, "qst_doneBtn")),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(128, 36),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
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
                                  padding: EdgeInsets.only(
                                      right: 16.0, bottom: 32.0),
                                  child: ElevatedButton(
                                    onPressed: () => continueToNextPage()
                                        ? nextPage()
                                        : showDialog(
                                            context: context,
                                            builder: (context) =>
                                                unansweredQuestionsAlert()),
                                    child: Text(
                                        getTranslated(context, "qst_nextBtn")),
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(128, 36),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        )),
                                  )),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, bottom: 32.0),
                                  child: OutlinedButton(
                                    onPressed:
                                        currentIndex == 0 ? null : previousPage,
                                    child: Text(getTranslated(
                                        context, "qst_previousBtn")),
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(128, 36),
                                        side: currentIndex == 0
                                            ? null
                                            : BorderSide(
                                                color: Colors.blue,
                                                style: BorderStyle.solid),
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0)),
                                        )),
                                  )),
                            ),
                          ],
                        )
                ]),
              ),
            );
          } else {
            print("snapshot has no data: " + snapshot.data.toString());
            //TODO: show error page if no questions iinside snapshot
            return Container();
          }
        });
  }
}
