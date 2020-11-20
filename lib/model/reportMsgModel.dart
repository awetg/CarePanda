class ReportMsgModel {
  final String message;
  final String date;

  ReportMsgModel({
    this.message,
    this.date,
  });

  factory ReportMsgModel.fromMap(Map<String, dynamic> json) {
    return ReportMsgModel(message: json["message"], date: json["date"]);
  }

  Map<String, dynamic> toMap() {
    return {"message": message, "date": date};
  }
}
