import 'package:farstore/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class CustomContainerBanner extends StatelessWidget {
  final String imageUrl;
  final String titleText;
  final String subtitleText;

  const CustomContainerBanner({
    Key? key,
    required this.imageUrl,
    required this.titleText,
    required this.subtitleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 243, 214, 119), Colors.white], // Gradient from bottom to top
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        shape: BoxShape.rectangle, // You can adjust the shape as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _buildContentColumn(
              imageUrl: imageUrl,
              title: titleText,
              subtitle: subtitleText,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDivider(),
              _buildCenterIcon(),
              _buildDivider(),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildContentColumn(
              imageUrl:
                  'https://res.cloudinary.com/dybzzlqhv/image/upload/v1727670900/fmvqjdmtzq5chmeqsyhb.png',
              title: 'Free delivery',
              subtitle: 'On first 10 orders',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentColumn({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          imageUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              color: GlobalVariables.greenColor,
              fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(
              fontSize: 12, color: Colors.brown, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 20, // Adjust the height for the divider container
      child: const VerticalDivider(
        color: Colors.grey,
        thickness: 1,
        indent: 0,
        endIndent: 0,
      ),
    );
  }

  Widget _buildCenterIcon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown, width: 1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.add, size: 20, color: Colors.brown),
    );
  }
}


// Custom shape border class
// class CustomNotchBorder extends ShapeBorder {
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     return getOuterPath(rect, textDirection: textDirection);
//   }

//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     final Path path = Path();
//     final double notchRadius = 10.0;
//     final double cornerRadius = 10.0;

//     // Start from top-left
//     path.moveTo(rect.left, rect.top + cornerRadius);

//     // Top-left corner
//     path.quadraticBezierTo(
//         rect.left, rect.top, rect.left + cornerRadius, rect.top);

//     // Top edge to notch start
//     path.lineTo(rect.center.dx - notchRadius, rect.top);

//     // Top semi-circle notch
//     path.arcTo(
//         Rect.fromCircle(
//             center: Offset(rect.center.dx, rect.top), radius: notchRadius),
//         pi,
//         -pi,
//         false);

//     // Top edge from notch to right corner
//     path.lineTo(rect.right - cornerRadius, rect.top);

//     // Top-right corner
//     path.quadraticBezierTo(
//         rect.right, rect.top, rect.right, rect.top + cornerRadius);

//     // Right edge
//     path.lineTo(rect.right, rect.bottom - cornerRadius);

//     // Bottom-right corner
//     path.quadraticBezierTo(
//         rect.right, rect.bottom, rect.right - cornerRadius, rect.bottom);

//     // Bottom edge to notch start
//     path.lineTo(rect.center.dx + notchRadius, rect.bottom);

//     // Bottom semi-circle notch
//     path.arcTo(
//         Rect.fromCircle(
//             center: Offset(rect.center.dx, rect.bottom), radius: notchRadius),
//         0,
//         -pi,
//         false);

//     // Bottom edge from notch to left corner
//     path.lineTo(rect.left + cornerRadius, rect.bottom);

//     // Bottom-left corner
//     path.quadraticBezierTo(
//         rect.left, rect.bottom, rect.left, rect.bottom - cornerRadius);

//     // Close the path
//     path.close();
//     return path;
//   }

//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

//   @override
//   ShapeBorder scale(double t) => this;
// }
