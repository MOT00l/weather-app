import 'package:flutter/material.dart';

class TemperatureGraphPainter extends CustomPainter {
  final List<double> maxTemps;
  final List<double> minTemps;

  TemperatureGraphPainter({
    required this.maxTemps,
    required this.minTemps,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final minPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = Colors.white;

    final maxPath = Path();
    final minPath = Path();

    const double topY = 110;
    const double bottomY = 190;

    final maxTempValue = maxTemps.reduce((a, b) => a > b ? a : b);

    final minTempValue = minTemps.reduce((a, b) => a < b ? a : b);

    final xStep = size.width / (maxTemps.length - 1);

    for (int i = 0; i < maxTemps.length; i++) {
      final x = i * xStep;

      final maxY = topY - ((maxTemps[i] - maxTempValue) * 8);

      final minY = bottomY - ((minTemps[i] - minTempValue) * 8);

      if (i == 0) {
        maxPath.moveTo(x, maxY);
        minPath.moveTo(x, minY);
      } else {
        maxPath.lineTo(x, maxY);
        minPath.lineTo(x, minY);
      }

      canvas.drawCircle(
        Offset(x, maxY),
        5,
        dotPaint,
      );

      canvas.drawCircle(
        Offset(x, minY),
        5,
        dotPaint,
      );
    }

    canvas.drawPath(maxPath, maxPaint);
    canvas.drawPath(minPath, minPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
