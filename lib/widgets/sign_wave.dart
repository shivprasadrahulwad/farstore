import 'package:flutter/material.dart';
import 'dart:math';

class SineWavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double frequency;
  final double strokeWidth;

  SineWavePainter({
    this.color = Colors.black,
    this.amplitude = 3,
    this.frequency = 15,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    for (double x = 0; x <= size.width; x++) {
      final y = amplitude * sin((frequency * 2 * pi * x) / size.width) + amplitude;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}



class SineWaveClipper extends CustomClipper<Path> {
  final double amplitude;
  final double frequency;

  SineWaveClipper({
    this.amplitude = 3,
    this.frequency = 15,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, amplitude);
    for (double x = 0; x <= size.width; x++) {
      final y = amplitude * sin((frequency * 2 * pi * x) / size.width) + amplitude;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}