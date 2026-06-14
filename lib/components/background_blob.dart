import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBlob extends StatefulWidget {
  final Color color;
  final Color targetColor;
  final double size;
  final Offset startOffset;
  final Offset endOffset;
  final bool clockwise;

  const AnimatedBlob({
    super.key,
    required this.color,
    required this.size,
    required this.startOffset,
    required this.endOffset,
    required this.targetColor,
    required this.clockwise,
  });

  @override
  State<AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final AnimationController transitionController;

  Color? previousColor;

  @override
  void initState() {
    super.initState();

    previousColor = widget.color;

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    transitionController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedBlob oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.color != widget.color) {
      previousColor = oldWidget.color;

      controller
        ..reset()
        ..forward();

      transitionController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller,
        transitionController,
      ]),
      builder: (context, child) {
        final animatedColor = Color.lerp(
          previousColor,
          widget.color,
          transitionController.value,
        )!;

        final orbitProgress = Curves.easeInOut.transform(controller.value);

        final orbitAngle =
            orbitProgress * 2 * math.pi * (widget.clockwise ? 1 : -1);

        final orbitOffset = Offset(
          40 * (math.cos(orbitAngle) - 1),
          40 * math.sin(orbitAngle),
        );

        final finalOffset = widget.startOffset + orbitOffset;

        final half = widget.size / 2;

        return Positioned(
          left: finalOffset.dx - half,
          top: finalOffset.dy - half,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 90,
              sigmaY: 90,
            ),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: animatedColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
