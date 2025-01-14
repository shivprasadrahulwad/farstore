import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // Ensure you have the right import for SfCircularChart

class RadialBarChartWidget extends StatelessWidget {
  final int status0Count;
  final int status1Count;
  final int status2Count;
  final int status3Count;

  const RadialBarChartWidget({
    Key? key,
    required this.status0Count,
    required this.status1Count,
    required this.status2Count,
    required this.status3Count,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    int totalCount = status0Count + status1Count + status2Count + status3Count;
    return SfCircularChart(
      series: <RadialBarSeries<_ChartData, String>>[
        RadialBarSeries<_ChartData, String>(
          dataSource: getChartData(),
          xValueMapper: (_ChartData data, _) => data.task,
          yValueMapper: (_ChartData data, _) => data.progress,
          maximumValue: 100,
          cornerStyle: CornerStyle.bothCurve,
          gap: '10%',
          radius: '100%',
          innerRadius: '30%',
          dataLabelSettings: const DataLabelSettings(isVisible: false), // Set to false to hide data labels
        ),
      ],
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Container(
            child: Text(
              'Total\n$totalCount', // Update this to show total counts if needed
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<_ChartData> getChartData() {
    return <_ChartData>[
      _ChartData('Status 0', status0Count.toDouble()), // Use the counts here
      _ChartData('Status 1', status1Count.toDouble()),
      _ChartData('Status 2', status2Count.toDouble()),
      _ChartData('Status 3', status3Count.toDouble()),
    ];
  }
}

class _ChartData {
  _ChartData(this.task, this.progress);
  final String task;
  final double progress;
}
