import 'package:flutter/material.dart';

import '../utilities/constants.dart';

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
      ..color = kTextColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final minPaint = Paint()
      ..color = kTextColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()..color = kIconColor;

    final maxPath = Path();
    final minPath = Path();

    const double topY = 110;
    const double bottomY = 190;

    final maxTempValue = maxTemps.reduce((a, b) => a > b ? a : b);

    final minTempValue = minTemps.reduce((a, b) => a < b ? a : b);

    final sectionWidth = size.width / maxTemps.length;
    // final xStep = size.width / (maxTemps.length - 1);

    for (int i = 0; i < maxTemps.length; i++) {
      final x = sectionWidth * i + sectionWidth / 2;
      // final x = i * xStep;

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
      final maxTextPainter = TextPainter(
        text: TextSpan(
          text: "${maxTemps[i].round()}°",
          style: TextStyle(
            color: kIconColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      maxTextPainter.layout();

      maxTextPainter.paint(
        canvas,
        Offset(
          x - maxTextPainter.width / 2,
          maxY - 35,
        ),
      );

      canvas.drawCircle(
        Offset(x, minY),
        5,
        dotPaint,
      );
      final minTextPainter = TextPainter(
        text: TextSpan(
          text: "${minTemps[i].round()}°",
          style: TextStyle(
            color: kIconColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      minTextPainter.layout();

      minTextPainter.paint(
        canvas,
        Offset(
          x - minTextPainter.width / 2,
          minY + 12,
        ),
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
