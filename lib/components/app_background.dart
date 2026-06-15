import 'package:flutter/material.dart';

import '../utilities/constants.dart';
import 'background_blob.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 1.6,
              colors: [
                kGradientOne,
                kGradientTwo,
                kGradientThree,
              ],
            ),
          ),
        ),
        AnimatedBlob(
          color: kBolbOne,
          targetColor: kBolbOne,
          clockwise: true,
          size: 400,
          startOffset: Offset(390, 80),
          endOffset: Offset(180, 20),
        ),
        AnimatedBlob(
          color: kBolbTwo,
          targetColor: kBolbTwo,
          clockwise: false,
          size: 400,
          startOffset: Offset(30, 780),
          endOffset: Offset(-30, -780),
        ),
        child,
      ],
    );
  }
}
