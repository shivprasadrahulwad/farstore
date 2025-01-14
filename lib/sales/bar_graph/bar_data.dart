class IndividualBar {
  final int x;
  final double y;

  IndividualBar({required this.x, required this.y});
}

class BarData {
  final double sun;
  final double mon;
  final double tue;
  final double wed;
  final double thur;
  final double fri;
  final double sat;

  List<IndividualBar> barData = [];

  BarData({
    required this.sun,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thur,
    required this.fri,
    required this.sat
  });

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: sun),
      IndividualBar(x: 1, y: mon),
      IndividualBar(x: 2, y: tue),
      IndividualBar(x: 3, y: wed),
      IndividualBar(x: 4, y: thur),
      IndividualBar(x: 5, y: fri),
      IndividualBar(x: 6, y: sat),
    ];
  }
}