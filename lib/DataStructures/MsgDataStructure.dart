class MsgDataStructure {
  final String name;
  final String lastName;
  final String building;
  final int floor;
  final int age;
  final String message;
  final String gender;
  final int yearsInNokia;
  final String date;

  // Bool to determine wheter the card is expanded in the UI
  // When using real data, give all the msgs "Expnaded" as false
  bool expanded;

  MsgDataStructure(
      this.name,
      this.lastName,
      this.building,
      this.floor,
      this.age,
      this.message,
      this.expanded,
      this.gender,
      this.yearsInNokia,
      this.date);
}
