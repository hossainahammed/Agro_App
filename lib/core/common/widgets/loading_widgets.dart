import 'dart:math' as math;
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final double size;
  final Duration speed;

  const LoadingWidget({
    super.key,
    this.size = 44.8, // 2.8rem equivalent (assuming 1rem = 16px)
    this.speed = const Duration(milliseconds: 900), // --uib-speed: 0.9s
  });

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.speed)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: List.generate(8, (index) {
          // CSS delays: 0, -0.875, -0.75, -0.625, -0.5, -0.375, -0.25, -0.125
          // In Flutter, we add to the animation value to simulate a negative delay (faking the head start)
          final double delayFactor = index == 0 ? 0.0 : 1.0 - (index * 0.125);

          return Transform.rotate(
            // Rotates each container by 45 degrees multiplied by its index
            angle: index * 45 * math.pi / 180,
            child: _DotSpinnerDot(
              controller: _controller,
              delayFactor: delayFactor,
              spinnerSize: widget.size,
            ),
          );
        }),
      ),
    );
  }
}

class _DotSpinnerDot extends StatelessWidget {
  final AnimationController controller;
  final double delayFactor;
  final double spinnerSize;

  const _DotSpinnerDot({
    required this.controller,
    required this.delayFactor,
    required this.spinnerSize,
  });

  @override
  Widget build(BuildContext context) {
    final double dotSize = spinnerSize * 0.2; // height: 20%, width: 20%

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Stagger the animation progress based on the dot's specific delay factor
        double progress = controller.value + delayFactor;
        if (progress > 1.0) progress -= 1.0;

        // Replicating the ease-in-out pulse0112 curve (0% -> 0, 50% -> 1, 100% -> 0)
        double scale;
        double opacity;
        if (progress < 0.5) {
          double t = progress / 0.5; // Normalized 0 to 1
          double curve = Curves.easeInOut.transform(t);
          scale = curve;
          opacity = 0.5 + (curve * 0.5); // 0.5 to 1.0
        } else {
          double t = (progress - 0.5) / 0.5; // Normalized 0 to 1
          double curve = Curves.easeInOut.transform(t);
          scale = 1.0 - curve;
          opacity = 1.0 - (curve * 0.5); // 1.0 to 0.5
        }

        return Container(
          width: spinnerSize,
          height: spinnerSize,
          // Aligns the dot to the left center, matching `justify-content: flex-start` in CSS
          alignment: Alignment.centerLeft,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    // Outer glow/shadow mix matching the CSS styling
                    BoxShadow(
                      color: const Color(0xFF121F35).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 0),
                    ),
                    BoxShadow(
                      color: const Color(0x5F96CACA), // rgb(95, 150, 202)
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
