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
          size: 400,
          startOffset: Offset(250, -80),
          endOffset: Offset(180, 20),
        ),
        AnimatedBlob(
          color: kBolbTwo,
          size: 400,
          startOffset: Offset(-120, 650),
          endOffset: Offset(-40, 560),
        ),
        child,
      ],
    );
  }
}
