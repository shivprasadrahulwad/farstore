import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Ensures the content is scrollable if needed
      child: Column(
        children: [
          // First Container (Blue, Top Radius 15)
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
              children: [
                Row(
                  children: [
                    // Icon inside a container with radius 10
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.alarm, color: Colors.blue),
                    ),
                  ],
                ),
                // Column with Rows for "Free delivery" and "NO delivery charges"
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Free delivery',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'No delivery charges',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16), // Space between the first and second containers
          
          // Second Container (Grey, Bottom Radius 15)
          Container(

            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
              children: [
                Row(
                  children: [
                    Text(
                      'Remaining',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // Progress bar with text '02.15 PM'
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: 0.5, // Example value, adjust as needed
                          color: Colors.blue,
                          backgroundColor: Colors.grey[300],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '02.15 PM',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    // "Ends in 45 min"
                    Text(
                      'Ends in 45 min',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
