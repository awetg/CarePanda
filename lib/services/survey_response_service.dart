import 'package:carePanda/model/question_item.dart';
import 'package:carePanda/model/survey_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LocalStorageService.dart';
import 'ServiceLocator.dart';

class SurveyResponseService {
  static final SurveyResponseService _surveyResponseService =
      SurveyResponseService._privateConstructor();

  final Map<String, SurveyResponse> _responses = {};

  factory SurveyResponseService() {
    return _surveyResponseService;
  }

  SurveyResponseService._privateConstructor();

  // empty the response map when starting answering new survey
  void clearResponseMap() => _responses.clear();

  // instantiate response object for a given question
  void initResponseForQuestion(QuestionItem question) {
    if (!_responses.containsKey(question.id)) {
      _responses[question.id] = SurveyResponse(
          questionId: question.id,
          type: question.type,
          value: "",
          freeText: "",
          time: Timestamp.now(),
          userId: locator<LocalStorageService>().anonymousUserId);
    }
  }

  // get freeText value of suvery response object using question id
  String getFreeTextById(String questionId) => _responses[questionId].freeText;

  // get value of survey response object using question id
  String getResponseValueById(String questionId) =>
      _responses[questionId].value;

  // check if all survey questions were answered before submitting to cloud firestore
  bool allQuestionsAnswered() {
    if (_responses.isNotEmpty) {
      return _responses.values
                  .firstWhere((v) => v.value == "", orElse: () => null) ==
              null
          ? true
          : false;
    } else
      return false;
  }

  // update the response value by question id
  void updateResponseValue(String questionId, String newValue) {
    if (_responses.containsKey(questionId)) {
      _responses[questionId].value = newValue;
    }
  }

  // update free text value of the response using question id
  void updateFreeText(String questionId, String freeText) {
    if (_responses.containsKey(questionId)) {
      _responses[questionId].freeText = freeText;
    }
  }

  // get all response object as a list
  List<SurveyResponse> getAllResponses() => _responses.values.toList();
}
