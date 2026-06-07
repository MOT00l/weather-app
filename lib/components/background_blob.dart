import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBlob extends StatefulWidget {
  final Color color;
  final double size;
  final Offset startOffset;
  final Offset endOffset;

  const AnimatedBlob({
    super.key,
    required this.color,
    required this.size,
    required this.startOffset,
    required this.endOffset,
  });

  @override
  State<AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<AnimatedBlob>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final offset = Offset.lerp(
          widget.startOffset,
          widget.endOffset,
          controller.value,
        )!;

        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: child!,
        );
      },
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 120,
          sigmaY: 120,
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
