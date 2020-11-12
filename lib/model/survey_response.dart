import 'package:carePanda/model/question_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResponse {
  final String questionId;
  final QuestionType type;
  String value;
  String freeText;
  final Timestamp time;

  SurveyResponse(
      {this.questionId, this.type, this.value, this.freeText, this.time});

  // Convert survey response from Firebase Firestore map of values to type of SurveyResponse
  factory SurveyResponse.fromMap(Map<String, dynamic> json) {
    return SurveyResponse(
        questionId: json["questionId"],
        value: json["value"],
        freeText: json["freeText"],
        time: json["time"]);
  }

  // Convert survey response from SurveyResponse to Firebase Firestore map of values
  Map<String, dynamic> toMap() {
    return {
      "questionId": questionId,
      "value": value,
      "freeText": freeText,
      "time": time
    };
  }
}
