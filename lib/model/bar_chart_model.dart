class BarChartModel {
  final String option;
  final DateTime dateTime;
  final int value;

  const BarChartModel({this.option, this.dateTime, this.value});

  @override
  String toString() {
    return "option: ${this.option}, date: ${this.dateTime}, value: ${this.value}";
  }
}

class SliderBarChartModel {
  final int x;
  final int y;

  const SliderBarChartModel({this.x, this.y});
}
