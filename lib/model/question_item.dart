// Survey question item
import 'dart:convert';

import 'package:flutter/material.dart';

class QuestionItem {
  // question id
  @required
  final String id;
  @required
  final String question;
  // type of question,
  @required
  final QuestionType type;
  // max number if the type of question is range selection, min is always 0
  final double rangeMax;
  // list of options if the type of question is single or multiple selction
  final List<String> options;
  // show free text box if set true, filling free text box is always optional for user
  final bool freeText;

  const QuestionItem(
      {this.id,
      this.question,
      this.type,
      this.rangeMax = 0,
      this.options = const [],
      this.freeText = false});

  // Convert question from Firebase Firestore map of values to type of QuestionItem
  factory QuestionItem.fromMap(Map<String, dynamic> json) {
    return QuestionItem(
        id: json["id"] as String,
        question: json["question"],
        type:
            QuestionType.values.firstWhere((e) => e.toString() == json["type"]),
        rangeMax: ((json["rangeMax"] ?? 0) as int).toDouble(),
        options: List<String>.from(jsonDecode(json["options"] ?? "[]")),
        freeText: json["freeText"] ?? false);
  }

  // Convert question from QuestionItem to Firebase Firestore map of values
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "question": question,
      "type": type.toString(),
      "rangeMax": rangeMax,
      "options": options,
      "freeText": freeText,
    };
  }
}

enum QuestionType { RangeSelection, SingleSelection, MultiSelection }
