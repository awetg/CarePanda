// Survey question item
class QuestionItem {
  // question id
  final int id;
  final String question;
  // type of question,
  final QuestionType type;
  // max number if the type of question is range selection, min is always 0
  final double rangeMax;
  // list of options if the type of question is single or multiple selction
  final List<String> options;
  // show free text box if set true, filling free text box is always optional for user
  final bool freeText;

  const QuestionItem(this.id, this.question, this.type, this.rangeMax,
      this.options, this.freeText);
}

enum QuestionType { RangeSelection, SingleSelection, MultiSelection }
