import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedLinePainter(),
      child: Container(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashWidth = 5.0;
    double dashSpace = 5.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
