import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import 'package:project_structure/features/chat/presentation/controllers/chat_controller.dart';
import 'package:project_structure/features/chat/presentation/views/chat_list_screen.dart';
import '../controllers/delivery_navigation_controller.dart';
import 'delivery_dashboard_screen.dart';
import 'earnings/earnings_screen.dart';
import 'jobs/available_jobs_screen.dart';
import 'profile/delivery_profile_screen.dart';

class DeliveryMainScreen extends StatelessWidget {
  const DeliveryMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DeliveryNavigationController());

    // Ensure ChatController is available for Messages tab
    if (!Get.isRegistered<ChatController>()) {
      Get.lazyPut<ChatController>(() => ChatController(), fenix: true);
    }

    final List<Widget> screens = [
      const DeliveryDashboardScreen(),
      const AvailableJobsScreen(),
      const EarningsScreen(),
      const ChatListScreen(),
      const DeliveryProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE),
      body: Obx(() => screens[controller.currentIndex.value]),
      bottomNavigationBar: _buildBottomNavigationBar(context, controller),
    );
  }

  // ==========================================================
  // BOTTOM NAVIGATION BAR (Matching Mockup)
  // ==========================================================
  Widget _buildBottomNavigationBar(
    BuildContext context,
    DeliveryNavigationController controller,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE2EDE4).withValues(alpha: 0.7),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: MediaQuery.of(context).padding.bottom > 0
            ? MediaQuery.of(context).padding.bottom + 4.h
            : 8.h,
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              iconBuilder: (color) => NavHomeIcon(color: color, size: 22.sp),
              label: "Home",
              controller: controller,
            ),
            _buildNavItem(
              index: 1,
              iconBuilder: (color) => NavMissionsIcon(color: color, size: 22.sp),
              label: "Missions",
              controller: controller,
            ),
            _buildNavItem(
              index: 2,
              iconBuilder: (color) => NavEarningsIcon(color: color, size: 22.sp),
              label: "Earnings",
              controller: controller,
            ),
            _buildNavItem(
              index: 3,
              iconBuilder: (color) => NavMessagesIcon(color: color, size: 22.sp),
              label: "Messages",
              controller: controller,
              badgeCount: controller.unreadMessages.value,
            ),
            _buildNavItem(
              index: 4,
              iconBuilder: (color) => NavProfileIcon(color: color, size: 22.sp),
              label: "Profile",
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required Widget Function(Color color) iconBuilder,
    required String label,
    required DeliveryNavigationController controller,
    int? badgeCount,
  }) {
    final isSelected = controller.currentIndex.value == index;
    final itemColor = isSelected ? const Color(0xFF236830) : const Color(0xFF7A8C80);

    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 62.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                iconBuilder(itemColor),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -4.h,
                    right: -7.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935), // Vibrant red notification badge
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 15.h,
                        minHeight: 15.h,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "$badgeCount",
                        style: GoogleFonts.inter(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 3.h),

            // Label
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: itemColor,
                height: 1.1,
              ),
            ),
            SizedBox(height: 3.h),

            // Active pill indicator underneath Home
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 16.w : 0,
              height: 3.h,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF236830) : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// VECTOR NAVBAR ICONS MATCHING FIGMA LUCIDE / FEATHER SPECIFICATION
// ====================================================================

/// 1. Home Icon (Outlined house with door arch inside)
class NavHomeIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const NavHomeIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavHomePainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _NavHomePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _NavHomePainter({required this.color, required this.strokeWidth});

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

    // House outer path
    final housePath = Path()
      ..moveTo(3.5 * sx, 10 * sy)
      ..lineTo(12 * sx, 3.2 * sy)
      ..lineTo(20.5 * sx, 10 * sy)
      ..lineTo(20.5 * sx, 20.5 * sy)
      ..lineTo(3.5 * sx, 20.5 * sy)
      ..close();

    // Door arch inside
    final doorPath = Path()
      ..moveTo(9.5 * sx, 20.5 * sy)
      ..lineTo(9.5 * sx, 14 * sy)
      ..arcToPoint(
        Offset(14.5 * sx, 14 * sy),
        radius: Radius.circular(2.5 * sx),
      )
      ..lineTo(14.5 * sx, 20.5 * sy);

    canvas.drawPath(housePath, paint);
    canvas.drawPath(doorPath, paint);
  }

  @override
  bool shouldRepaint(covariant _NavHomePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// 2. Missions Icon (Outlined Lucide Zap lightning bolt)
class NavMissionsIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const NavMissionsIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavMissionsPainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _NavMissionsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _NavMissionsPainter({required this.color, required this.strokeWidth});

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

    // Lucide Zap points: (13, 2) -> (4, 13.5) -> (12, 13.5) -> (11, 22) -> (20, 10.5) -> (12, 10.5) -> close
    final path = Path()
      ..moveTo(13 * sx, 2 * sy)
      ..lineTo(4 * sx, 13.5 * sy)
      ..lineTo(12 * sx, 13.5 * sy)
      ..lineTo(11 * sx, 22 * sy)
      ..lineTo(20 * sx, 10.5 * sy)
      ..lineTo(12 * sx, 10.5 * sy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NavMissionsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// 3. Earnings Icon (Clean $ symbol with vertical bar through the S)
class NavEarningsIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const NavEarningsIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavEarningsPainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _NavEarningsPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _NavEarningsPainter({required this.color, required this.strokeWidth});

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

    // Center vertical stroke
    canvas.drawLine(Offset(12 * sx, 2.5 * sy), Offset(12 * sx, 21.5 * sy), paint);

    // S curve path
    final sPath = Path()
      ..moveTo(16.5 * sx, 6.5 * sy)
      ..cubicTo(16 * sx, 5.2 * sy, 8.5 * sx, 5.2 * sy, 8.5 * sx, 9 * sy)
      ..cubicTo(8.5 * sx, 12 * sy, 15.5 * sx, 12 * sy, 15.5 * sy, 15 * sy)
      ..cubicTo(15.5 * sx, 18.8 * sy, 8 * sx, 18.8 * sy, 7.5 * sx, 17.5 * sy);

    canvas.drawPath(sPath, paint);
  }

  @override
  bool shouldRepaint(covariant _NavEarningsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// 4. Messages Icon (Speech bubble with text lines inside)
class NavMessagesIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const NavMessagesIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavMessagesPainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _NavMessagesPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _NavMessagesPainter({required this.color, required this.strokeWidth});

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

    // Speech bubble body
    final bubblePath = Path()
      ..moveTo(4 * sx, 8 * sy)
      ..arcToPoint(Offset(8 * sx, 4 * sy), radius: Radius.circular(4 * sx))
      ..lineTo(16 * sx, 4 * sy)
      ..arcToPoint(Offset(20 * sx, 8 * sy), radius: Radius.circular(4 * sx))
      ..lineTo(20 * sx, 13 * sy)
      ..arcToPoint(Offset(16 * sx, 17 * sy), radius: Radius.circular(4 * sx))
      ..lineTo(8 * sx, 17 * sy)
      ..lineTo(4 * sx, 20.5 * sy)
      ..lineTo(4 * sx, 8 * sy);

    canvas.drawPath(bubblePath, paint);

    // Inner horizontal message lines
    canvas.drawLine(Offset(8 * sx, 8.5 * sy), Offset(14 * sx, 8.5 * sy), paint);
    canvas.drawLine(Offset(8 * sx, 12 * sy), Offset(12 * sx, 12 * sy), paint);
  }

  @override
  bool shouldRepaint(covariant _NavMessagesPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// 5. Profile Icon (User circular head with shoulder arc)
class NavProfileIcon extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const NavProfileIcon({
    super.key,
    required this.color,
    this.size = 24,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _NavProfilePainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class _NavProfilePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  const _NavProfilePainter({required this.color, required this.strokeWidth});

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

    // Head circle
    canvas.drawCircle(Offset(12 * sx, 7.5 * sy), 4.2 * sx, paint);

    // Shoulder arc
    final shoulderPath = Path()
      ..moveTo(4.5 * sx, 20.5 * sy)
      ..cubicTo(5.5 * sx, 15.5 * sy, 8.5 * sx, 14.5 * sy, 12 * sx, 14.5 * sy)
      ..cubicTo(15.5 * sx, 14.5 * sy, 18.5 * sx, 15.5 * sy, 19.5 * sx, 20.5 * sy);

    canvas.drawPath(shoulderPath, paint);
  }

  @override
  bool shouldRepaint(covariant _NavProfilePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
