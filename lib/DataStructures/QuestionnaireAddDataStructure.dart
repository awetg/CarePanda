class QuestionnaireAddDataStructure {
  final bool freeText;
  final String question;
  final String questionType;
  // Array of options
  final options;
  // Max range of slider
  final int maxRange;

  QuestionnaireAddDataStructure(
    this.freeText,
    this.question,
    this.questionType,
    this.options,
    this.maxRange,
  );
}
