import 'dart:async';
import 'package:farstore/constants/global_variables.dart';
import 'package:flutter/material.dart';

class CountdownStopwatch extends StatefulWidget {
  final Duration initialDuration;

  const CountdownStopwatch({Key? key, required this.initialDuration})
      : super(key: key);

  @override
  _CountdownStopwatchState createState() => _CountdownStopwatchState();
}

class _CountdownStopwatchState extends State<CountdownStopwatch> {
  late Duration _remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int days = _remainingTime.inDays;
    int hours = _remainingTime.inHours % 24;
    int minutes = _remainingTime.inMinutes % 60;
    int seconds = _remainingTime.inSeconds % 60;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: GlobalVariables.blueBackground,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Delivery chrges schedule',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GlobalVariables.blueTextColor
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 250, 208, 136),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Scheduled',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                // Conditionally render time sections to take equal space
                if (days > 0) ...[
                  Expanded(
                      child: _buildTimeSection(
                          'Days', days.toString().padLeft(2, '0'))),
                  Expanded(
                      child: _buildTimeSection(
                          'Hours', hours.toString().padLeft(2, '0'))),
                  Expanded(
                      child: _buildTimeSection(
                          'Minutes', minutes.toString().padLeft(2, '0'))),
                ] else ...[
                  Expanded(
                      child: _buildTimeSection(
                          'Hours', hours.toString().padLeft(2, '0'))),
                  Expanded(
                      child: _buildTimeSection(
                          'Minutes', minutes.toString().padLeft(2, '0'))),
                  Expanded(
                      child: _buildTimeSection(
                          'Seconds', seconds.toString().padLeft(2, '0'))),
                ],
              ],
            ),
          ],
        ));
  }

  Widget _buildTimeSection(String label, String value) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: GlobalVariables.blueTextColor
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
