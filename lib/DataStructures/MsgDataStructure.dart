class MsgDataStructure {
  final String name;
  final String lastName;
  final int building;
  final int floor;
  final int age;
  final String message;
  final int gender;
  final int yearsInNokia;
  final String date;

  // Bool to determine wheter the card is expanded in the UI
  // When using real data, give all the msgs "Expnaded" as false
  bool expanded;

  MsgDataStructure(
      {this.name,
      this.lastName,
      this.building,
      this.floor,
      this.age,
      this.message,
      this.expanded,
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
      age: json["age"],
      gender: json["gender"],
      yearsInNokia: json["yearsInNokia"],
      date: json["date"],
      expanded: json["expanded"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "name": name,
      "lastName": lastName,
      "building": building,
      "floor": floor,
      "age": age,
      "gender": gender,
      "yearsInNokia": yearsInNokia,
      "date": date,
      "expanded": expanded
    };
  }
}
