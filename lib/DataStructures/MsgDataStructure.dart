class MsgDataStructure {
  final String name;
  final String lastName;
  final int building;
  final int floor;
  final int birthYear;
  final String message;
  final int gender;
  final int yearsInNokia;
  final String date;

  // Bool to determine wheter the card is expanded in the UI
  // When using real data, give all the msgs "Expnaded" as false

  MsgDataStructure(
      {this.name,
      this.lastName,
      this.building,
      this.floor,
      this.birthYear,
      this.message,
      this.gender,
      this.yearsInNokia,
      this.date});

  factory MsgDataStructure.fromMap(Map<String, dynamic> json) {
    return MsgDataStructure(
      message: json["message"],
      name: json["name"],
      lastName: json["lastName"],
      building: json["building"],
      floor: json["floor"],
      birthYear: json["birthYear"],
      gender: json["gender"],
      yearsInNokia: json["yearsInNokia"],
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
      "yearsInNokia": yearsInNokia,
      "date": date,
    };
  }
}
