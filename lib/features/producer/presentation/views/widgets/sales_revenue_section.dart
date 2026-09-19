import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_colors.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/producer_dashboard_controller.dart';

/// Sales Revenue section containing the header title, period filters,
/// and the custom spline chart card.
class SalesRevenueSection extends StatelessWidget {
  final ProducerDashboardController controller;

  const SalesRevenueSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header: "Sales Revenue" title + Period Filter Buttons (Week, Month, Year)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sales Revenue",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPeriodPill("Week"),
                  SizedBox(width: 4.w),
                  _buildPeriodPill("Month"),
                  SizedBox(width: 4.w),
                  _buildPeriodPill("Year"),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // 2. Chart Card Container
        Container(
          width: double.infinity,
          height: 225.h,
          padding: EdgeInsets.fromLTRB(14.w, 16.h, 14.w, 12.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.containerBorder.withAlpha(120),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(8),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Obx(() {
            final data = controller.currentRevenueData;
            return CustomPaint(
              size: Size.infinite,
              painter: _SalesRevenueSplinePainter(
                data: data,
                primaryColor: AppColors.primary,
                gridLineColor: const Color(0xFFEEF2F6),
                axisTextColor: const Color(0xFF94A3B8),
                boldTextColor: AppColors.textPrimary,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPeriodPill(String period) {
    final isSelected = controller.selectedRevenuePeriod.value == period;

    return GestureDetector(
      onTap: () => controller.changeRevenuePeriod(period),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          period,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

/// Custom painter that renders:
/// - Y-axis labels ($20k, $16k, $12k, $8k, $4k, $0)
/// - Dashed horizontal grid lines
/// - Smooth Catmull-Rom to Bézier curve with green gradient fill
/// - Highlighted point at October with circular marker and vertical dashed drop-line
/// - X-axis labels (Jun, Jul, Aug, Sep, Oct, Nov)
class _SalesRevenueSplinePainter extends CustomPainter {
  final RevenueChartData data;
  final Color primaryColor;
  final Color gridLineColor;
  final Color axisTextColor;
  final Color boldTextColor;

  _SalesRevenueSplinePainter({
    required this.data,
    required this.primaryColor,
    required this.gridLineColor,
    required this.axisTextColor,
    required this.boldTextColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double yLabelWidth = 34.0;
    const double topPadding = 10.0;
    const double bottomPadding = 24.0;
    const double rightPadding = 8.0;

    final double chartLeft = yLabelWidth + 6.0;
    final double chartRight = size.width - rightPadding;
    final double chartTop = topPadding;
    final double chartBottom = size.height - bottomPadding;
    final double chartHeight = chartBottom - chartTop;
    final double chartWidth = chartRight - chartLeft;

    final yLabels = data.yLabels;
    final yTicksCount = yLabels.length;

    // 1. Draw Y-Axis Labels & Horizontal Dashed Gridlines
    final gridPaint = Paint()
      ..color = gridLineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < yTicksCount; i++) {
      final double progress = i / (yTicksCount - 1);
      final double yPos = chartTop + chartHeight * progress;

      // Draw dashed horizontal line
      _drawDashedHorizontalLine(
        canvas: canvas,
        startX: chartLeft,
        endX: chartRight,
        y: yPos,
        paint: gridPaint,
        dashWidth: 3.5,
        dashSpace: 3.0,
      );

      // Draw Y-axis text
      final textSpan = TextSpan(
        text: yLabels[i],
        style: GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          color: axisTextColor,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.right,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(yLabelWidth - textPainter.width, yPos - textPainter.height / 2),
      );
    }

    if (data.values.isEmpty) return;

    // 2. Compute Points for the curve
    final List<Offset> points = [];
    final int count = data.values.length;
    final double stepX = count > 1 ? chartWidth / (count - 1) : 0;
    final double rangeY = data.maxY - data.minY;

    for (int i = 0; i < count; i++) {
      final double x = chartLeft + i * stepX;
      final double clampedVal = data.values[i].clamp(data.minY, data.maxY);
      final double normalizedY = rangeY > 0 ? (clampedVal - data.minY) / rangeY : 0;
      final double y = chartBottom - (normalizedY * chartHeight);
      points.add(Offset(x, y));
    }

    // 3. Build Smooth Bézier Spline Path
    final Path linePath = Path();
    _buildSmoothSplinePath(linePath, points);

    // 4. Fill Area Under Curve with Soft Green Gradient
    final Path fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, chartBottom)
      ..lineTo(points.first.dx, chartBottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withAlpha(35),
          primaryColor.withAlpha(0),
        ],
      ).createShader(Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 5. Draw Stroke of the Line Chart
    final linePaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);

    // 6. Highlighted Point (Marker & Vertical Drop-line)
    if (data.highlightedIndex >= 0 && data.highlightedIndex < points.length) {
      final Offset highlightedPoint = points[data.highlightedIndex];

      // Vertical dashed line from the highlighted peak down to the bottom axis
      final indicatorLinePaint = Paint()
        ..color = primaryColor.withAlpha(120)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      _drawDashedVerticalLine(
        canvas: canvas,
        x: highlightedPoint.dx,
        startY: highlightedPoint.dy + 6.0,
        endY: chartBottom,
        paint: indicatorLinePaint,
        dashHeight: 3.5,
        dashSpace: 3.0,
      );

      // Outer / Marker Circle (White fill + Green border)
      final circleFillPaint = Paint()
        ..color = AppColors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(highlightedPoint, 5.5, circleFillPaint);

      final circleBorderPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.4
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(highlightedPoint, 5.5, circleBorderPaint);
    }

    // 7. Draw X-Axis Labels
    for (int i = 0; i < data.xLabels.length; i++) {
      final double xPos = chartLeft + i * stepX;
      final bool isBold = i == data.boldXIndex;

      final textSpan = TextSpan(
        text: data.xLabels[i],
        style: GoogleFonts.inter(
          fontSize: 11.0,
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          color: isBold ? boldTextColor : axisTextColor,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(xPos - textPainter.width / 2, chartBottom + 7.0),
      );
    }
  }

  /// Catmull-Rom to Cubic Bézier path generator for natural smooth undulations
  void _buildSmoothSplinePath(Path path, List<Offset> points) {
    if (points.isEmpty) return;
    path.moveTo(points[0].dx, points[0].dy);
    if (points.length == 1) return;

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];
      final p1 = points[i];
      final p2 = points[i + 1];
      final p3 = i < points.length - 2 ? points[i + 2] : p2;

      final cp1x = p1.dx + (p2.dx - p0.dx) / 6.0;
      final cp1y = p1.dy + (p2.dy - p0.dy) / 6.0;
      final cp2x = p2.dx - (p3.dx - p1.dx) / 6.0;
      final cp2y = p2.dy - (p3.dy - p1.dy) / 6.0;

      path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
    }
  }

  void _drawDashedHorizontalLine({
    required Canvas canvas,
    required double startX,
    required double endX,
    required double y,
    required Paint paint,
    required double dashWidth,
    required double dashSpace,
  }) {
    double currentX = startX;
    while (currentX < endX) {
      final double nextX = (currentX + dashWidth).clamp(startX, endX);
      canvas.drawLine(Offset(currentX, y), Offset(nextX, y), paint);
      currentX += dashWidth + dashSpace;
    }
  }

  void _drawDashedVerticalLine({
    required Canvas canvas,
    required double x,
    required double startY,
    required double endY,
    required Paint paint,
    required double dashHeight,
    required double dashSpace,
  }) {
    double currentY = startY;
    while (currentY < endY) {
      final double nextY = (currentY + dashHeight).clamp(startY, endY);
      canvas.drawLine(Offset(x, currentY), Offset(x, nextY), paint);
      currentY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _SalesRevenueSplinePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.gridLineColor != gridLineColor;
  }
}
