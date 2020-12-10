class HRMessage {
  final String id;
  final String name;
  final String lastName;
  final String building;
  final String floor;
  final String birthYear;
  final String message;
  final String gender;
  final String yearsWorked;
  final String date;

  // Bool to determine wheter the card is expanded in the UI
  // When using real data, give all the msgs "Expnaded" as false

  HRMessage(
      {this.id,
      this.name = "",
      this.lastName = "",
      this.building = "-1",
      this.floor = "-1",
      this.birthYear = "-1",
      this.message = "",
      this.gender = "-1",
      this.yearsWorked = "-1",
      this.date});

  factory HRMessage.fromMap(Map<String, dynamic> json) {
    return HRMessage(
      id: json["id"] as String,
      message: json["message"],
      name: json["name"],
      lastName: json["lastName"],
      building: json["building"],
      floor: json["floor"],
      birthYear: json["birthYear"],
      gender: json["gender"],
      yearsWorked: json["yearsWorked"],
      date: json["date"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "name": name,
      "lastName": lastName,
      "building": building,
      "floor": floor,
      "birthYear": birthYear,
      "gender": gender,
      "yearsWorked": yearsWorked,
      "date": date,
    };
  }
}
