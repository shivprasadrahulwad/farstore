import 'package:farstore/constants/global_variables.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBargraph extends StatefulWidget {
  final List<int> weeklyOrders; // List of weekly orders
  final int totalWeeklyOrders; // Total orders for the week
  final double weeklyGrowth; // Growth percentage

  const MyBargraph({
    Key? key,
    required this.weeklyOrders,
    required this.totalWeeklyOrders,
    required this.weeklyGrowth,
  }) : super(key: key);

  @override
  _MyBargraphState createState() => _MyBargraphState();
}

class _MyBargraphState extends State<MyBargraph> {
  late int totalSum;

  @override
  void initState() {
    super.initState();
    totalSum = calculateTotalSum();
  }

  int calculateTotalSum() {
    return widget.weeklyOrders.fold(0, (sum, order) => sum + order);
  }

  @override
  void didUpdateWidget(covariant MyBargraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weeklyOrders != widget.weeklyOrders) {
      setState(() {
        totalSum = calculateTotalSum();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Orders',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                widget.totalWeeklyOrders.toString(),
                style: const TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 30),
              Container(
                height: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF82D2BA),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 10,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${widget.weeklyGrowth}%',
                style: const TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                maxY: widget.weeklyOrders.reduce((a, b) => a > b ? a : b) * 1.2,
                minY: 0,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getBottomTitles,
                      reservedSize: 30,
                    ),
                  ),
                ),
                barGroups: List.generate(
                  widget.weeklyOrders.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: widget.weeklyOrders[index].toDouble(),
                        color: GlobalVariables.blueTextColor,
                        width: 25,
                        borderRadius: BorderRadius.circular(5),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: widget.weeklyOrders.reduce((a, b) => a > b ? a : b) * 1.2,
                          color: Colors.grey[200],
                        ),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ),
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('S', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('T', style: style);
        break;
      case 3:
        text = const Text('W', style: style);
        break;
      case 4:
        text = const Text('T', style: style);
        break;
      case 5:
        text = const Text('F', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(child: text, axisSide: meta.axisSide);
  }
}
