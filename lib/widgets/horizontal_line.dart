import 'package:farstore/constants/global_variables.dart';
import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9, // Adjust opacity as needed
      child: Container(
        height: 2,
        width: 150, // Adjust width of the divider
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black
                  .withOpacity(0.8), // Adjust color and opacity as needed
              Colors.black
                  .withOpacity(0.5), // Adjust color and opacity as needed
              Colors.black
                  .withOpacity(0.3), // Adjust color and opacity as needed
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.09),
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalLine1 extends StatelessWidget {
  const HorizontalLine1({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9, // Adjust opacity as needed
      child: Container(
        height: 2,
        width: 150, // Adjust width of the divider
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              GlobalVariables.lightBlueTextColor
                  .withOpacity(0.8), // Adjust color and opacity as needed
              GlobalVariables.lightBlueTextColor
                  .withOpacity(0.5), // Adjust color and opacity as needed
              GlobalVariables.lightBlueTextColor
                  .withOpacity(0.3), // Adjust color and opacity as needed
              GlobalVariables.lightBlueTextColor.withOpacity(0.2),
              GlobalVariables.lightBlueTextColor.withOpacity(0.09),
              GlobalVariables.lightBlueTextColor.withOpacity(0.05),
              GlobalVariables.lightBlueTextColor.withOpacity(0.02),
            ],
          ),
        ),
      ),
    );
  }
}
