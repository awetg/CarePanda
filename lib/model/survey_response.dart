import 'package:carePanda/model/question_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Question answer model
class SurveyResponse {
  @required
  final String questionId;
  final QuestionType type;
  String value;
  String freeText;
  final Timestamp time;
  @required
  final String userId;

  SurveyResponse(
      {this.questionId,
      this.type,
      this.value,
      this.freeText,
      this.time,
      this.userId});

  // Convert survey response from Firebase Firestore map of values to type of SurveyResponse
  factory SurveyResponse.fromMap(Map<String, dynamic> json) {
    return SurveyResponse(
        questionId: json["questionId"],
        type:
            QuestionType.values.firstWhere((e) => e.toString() == json["type"]),
        value: json["value"],
        freeText: json["freeText"],
        userId: json["userId"],
        time: json["time"]);
  }

  // Convert survey response from SurveyResponse to Firebase Firestore map of values
  Map<String, dynamic> toMap() {
    return {
      "questionId": questionId,
      "type": type.toString(),
      "value": value,
      "freeText": freeText,
      "userId": userId,
      "time": time
    };
  }
}
