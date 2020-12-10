class UserData {
  String name;
  String lastName;
  String birthYear;
  String gender;
  String building;
  String floor;
  String yearsWorked;
  UserData({
    this.name = "",
    this.lastName = "",
    this.birthYear = "-1",
    this.gender = "-1",
    this.building = "-1",
    this.floor = "-1",
    this.yearsWorked = "-1",
  });

  factory UserData.fromMap(Map<String, dynamic> json) {
    return UserData(
      name: json["name"],
      lastName: json["lastName"],
      birthYear: json["birthYear"],
      gender: json["gender"],
      building: json["building"],
      floor: json["floor"],
      yearsWorked: json["yearsWorked"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "lastName": lastName,
      "birthYear": birthYear,
      "gender": gender,
      "building": building,
      "floor": floor,
      "yearsWorked": yearsWorked,
    };
  }

  @override
  String toString() {
    return """
    name: $name,
    lastName: $lastName,
    birthYear: $birthYear,
    gender: $gender,
    building: $building,
    floor: $floor,
    yearsWorked: $yearsWorked,
    """;
  }
}
