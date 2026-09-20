import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Outlined vector navigation arrow matching the Figma Lucide/Feather navigation cursor design
class NavigationArrowIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const NavigationArrowIcon({
    super.key,
    this.size = 24,
    this.color = Colors.white,
    this.strokeWidth = 2.2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavigationArrowPainter(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _NavigationArrowPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _NavigationArrowPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // Standard Lucide polygon points: (3, 11) -> (22, 2) -> (13, 21) -> (11, 13) -> closed
    final path = Path()
      ..moveTo(3 * sx, 11 * sy)
      ..lineTo(22 * sx, 2 * sy)
      ..lineTo(13 * sx, 21 * sy)
      ..lineTo(11 * sx, 13 * sy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavigationArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Outlined 3D isometric delivery box icon matching the Figma package icon
class DeliveryBoxIcon extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const DeliveryBoxIcon({
    super.key,
    this.size = 24,
    this.color = const Color(0xFF236830),
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DeliveryBoxPainter(
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _DeliveryBoxPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const _DeliveryBoxPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final sx = size.width / 24.0;
    final sy = size.height / 24.0;

    // Outer cube outline
    // Top face: (12, 2) -> (21, 7) -> (12, 12) -> (3, 7) -> closed
    final topFace = Path()
      ..moveTo(12 * sx, 2 * sy)
      ..lineTo(21 * sx, 7 * sy)
      ..lineTo(12 * sx, 12 * sy)
      ..lineTo(3 * sx, 7 * sy)
      ..close();
    canvas.drawPath(topFace, paint);

    // Vertical edges: (3, 7) -> (3, 17), (21, 7) -> (21, 17), (12, 12) -> (12, 22)
    canvas.drawLine(Offset(3 * sx, 7 * sy), Offset(3 * sx, 17 * sy), paint);
    canvas.drawLine(Offset(21 * sx, 7 * sy), Offset(21 * sx, 17 * sy), paint);
    canvas.drawLine(Offset(12 * sx, 12 * sy), Offset(12 * sx, 22 * sy), paint);

    // Bottom edges: (3, 17) -> (12, 22) -> (21, 17)
    final bottomEdges = Path()
      ..moveTo(3 * sx, 17 * sy)
      ..lineTo(12 * sx, 22 * sy)
      ..lineTo(21 * sx, 17 * sy);
    canvas.drawPath(bottomEdges, paint);

    // Tape line down center of top face: (7.5, 4.5) -> (16.5, 9.5)
    canvas.drawLine(
      Offset(7.5 * sx, 4.5 * sy),
      Offset(16.5 * sx, 9.5 * sy),
      paint..strokeWidth = strokeWidth * 0.8,
    );
  }

  @override
  bool shouldRepaint(covariant _DeliveryBoxPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Stylized Map Route Painter for Screen 2
class StylizedMapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. Fill base canvas with road color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFEFF5F1),
    );

    // 2. Draw city blocks (rounded rectangles in soft sage #E0EBE2)
    final blockPaint = Paint()..color = const Color(0xFFDFEAE1);
    const int cols = 6;
    const int rows = 4;
    const double gap = 8.0;
    final double blockW = (size.width - (cols + 1) * gap) / cols;
    final double blockH = (size.height - (rows + 1) * gap) / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final left = gap + c * (blockW + gap);
        final top = gap + r * (blockH + gap);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(left, top, blockW, blockH),
            const Radius.circular(5.0),
          ),
          blockPaint,
        );
      }
    }

    // 3. Draw dashed active route connecting:
    // P1: Pickup (left: 20%, bottom: 65%)
    // P2: You (middle: 48%, height: 42%)
    // P3: Drop-off (right: 80%, top: 26%)
    final p1 = Offset(size.width * 0.20, size.height * 0.65);
    final p2 = Offset(size.width * 0.48, size.height * 0.45);
    final p3 = Offset(size.width * 0.80, size.height * 0.26);

    final routePath = Path()
      ..moveTo(p1.dx, p1.dy)
      ..cubicTo(size.width * 0.30, size.height * 0.55, size.width * 0.40, size.height * 0.48, p2.dx, p2.dy)
      ..cubicTo(size.width * 0.60, size.height * 0.40, size.width * 0.70, size.height * 0.30, p3.dx, p3.dy);

    // Route shadow / halo
    final routeHaloPaint = Paint()
      ..color = const Color(0xFF236830).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routeHaloPaint);

    // Route dashed green line
    final routeLinePaint = Paint()
      ..color = const Color(0xFF236830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, routePath, routeLinePaint, 6.0, 4.0);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint, double dashWidth, double dashSpace) {
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = math.min(dashWidth, metric.length - distance);
        final Path extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
