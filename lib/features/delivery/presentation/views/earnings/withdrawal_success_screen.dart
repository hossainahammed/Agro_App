import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../delivery_main_screen.dart';
import 'withdraw_earnings_screen.dart';

class WithdrawalSuccessScreen extends StatelessWidget {
  final double requestedAmount;
  final double fee;
  final double netAmount;
  final PayoutAccount account;
  final String transactionId;
  final String dateTime;

  const WithdrawalSuccessScreen({
    super.key,
    this.requestedAmount = 9800.0,
    this.fee = 147.0,
    this.netAmount = 9653.0,
    this.account = const PayoutAccount(
      id: 'momo_1',
      title: 'MTN Mobile Money',
      subtitle: '+234 803 ••• ••98',
      owner: 'Emeka Okafor',
      isDefault: true,
      isMobileMoney: true,
      eta: '5–30 min',
    ),
    this.transactionId = 'WDR-20240627-8821',
    this.dateTime = 'Fri 27 Jun, 9:41 AM',
  });

  String _formatAmount(double amount) {
    final parts = amount.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (int i = 0; i < parts.length; i++) {
      if (i > 0 && (parts.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(parts[i]);
    }
    return buffer.toString();
  }

  void _returnToWallet() {
    Get.offAll(() => const DeliveryMainScreen(initialIndex: 2));
  }

  void _copyReference(BuildContext context) {
    Clipboard.setData(ClipboardData(text: transactionId));
    AppSnackBar.success("Reference $transactionId copied to clipboard!");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _returnToWallet();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Concentric Radial Ambient Green Header with Celebration Badge & Sparkles
              _buildAmbientHeader(context),

              // 2. Body Details
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 28.h),
                child: Column(
                  children: [
                    // Headline
                    Text(
                      "Withdrawal Successful",
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF152218),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.h),

                    // Subtitle
                    Text(
                      "Your money is on its way. Sit tight!",
                      style: GoogleFonts.inter(
                        fontSize: 12.5.sp,
                        color: const Color(0xFF5A6E60),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18.h),

                    // 3. Amount Sent Green Card with Destination Pill
                    _buildAmountSentCard(),
                    SizedBox(height: 16.h),

                    // 4. Detailed Transaction Audit Table Card
                    _buildTransactionAuditCard(context),
                    SizedBox(height: 14.h),

                    // 5. SLA Support Notice Card
                    _buildSupportNoticeCard(),
                    SizedBox(height: 22.h),

                    // 6. Primary Action: [ Done — Back to Wallet ]
                    _buildDoneButton(),
                    SizedBox(height: 12.h),

                    // 7. Secondary Action: [ View All Transactions ↗ ]
                    _buildViewTransactionsButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // 1. AMBIENT CONCENTRIC CIRCLE GREEN HEADER WITH SPARKLES
  // ====================================================================
  Widget _buildAmbientHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0F3818),
            Color(0xFF184E23),
            Color(0xFF226732),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Bokeh Bubble Left
          Positioned(
            top: 40.h,
            left: -25.w,
            child: Container(
              width: 120.h,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.045),
              ),
            ),
          ),

          // Background Bokeh Bubble Right
          Positioned(
            top: 20.h,
            right: -30.w,
            child: Container(
              width: 140.h,
              height: 140.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Outer Concentric Radial Ring
          Container(
            margin: EdgeInsets.only(top: 24.h),
            width: 200.h,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF38A153).withValues(alpha: 0.20),
                width: 1.3,
              ),
            ),
          ),

          // Mid Concentric Radial Ring
          Container(
            margin: EdgeInsets.only(top: 24.h),
            width: 140.h,
            height: 140.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF38A153).withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
          ),

          // Floating Sparkle Particle Top-Left
          Positioned(
            top: 60.h,
            left: 105.w,
            child: _buildSparkleParticle(size: 6.w),
          ),

          // Floating Sparkle Particle Top-Right
          Positioned(
            top: 55.h,
            right: 110.w,
            child: _buildSparkleParticle(size: 5.w),
          ),

          // Floating Sparkle Particle Bottom-Left
          Positioned(
            bottom: 45.h,
            left: 115.w,
            child: _buildSparkleParticle(size: 4.5.w),
          ),

          // Floating Sparkle Particle Bottom-Right
          Positioned(
            bottom: 50.h,
            right: 115.w,
            child: _buildSparkleParticle(size: 5.5.w),
          ),

          // Top-Left Back Navigation Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: GestureDetector(
              onTap: _returnToWallet,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.22),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          // Center Celebration Badge with Vibrant Checkmark
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 24.h),
              width: 70.h,
              height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFF34A853), // Vibrant celebration emerald green
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF34A853).withValues(alpha: 0.45),
                    blurRadius: 22,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkleParticle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFA8F5B8).withValues(alpha: 0.85),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA8F5B8).withValues(alpha: 0.6),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 2. AMOUNT SENT GREEN CARD
  // ====================================================================
  Widget _buildAmountSentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1B5324),
            Color(0xFF236830),
            Color(0xFF2C7D3E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5324).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tracking header: AMOUNT SENT
          Text(
            "AMOUNT SENT",
            style: GoogleFonts.inter(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFA3DEB0),
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 6.h),

          // Primary Net Amount Display: ₦ 9,653
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "₦ ",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                _formatAmount(netAmount),
                style: GoogleFonts.inter(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Requested & fee breakdown subtext
          Text(
            "₦${_formatAmount(requestedAmount)} requested · ₦${_formatAmount(fee)} fee deducted",
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              color: const Color(0xFFD6E8DA),
            ),
          ),
          SizedBox(height: 16.h),

          // Inner Translucent Destination Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Phone / Bank Rounded Square Icon
                Container(
                  width: 34.h,
                  height: 34.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    account.isMobileMoney
                        ? Icons.phone_android_rounded
                        : Icons.account_balance_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 10.w),

                // Account Name & Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.title,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 1.5.h),
                      Text(
                        "${account.subtitle} · ${account.owner.split('·').first.trim()}",
                        style: GoogleFonts.inter(
                          fontSize: 10.5.sp,
                          color: const Color(0xFFD6E8DA),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ETA Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.5.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 11,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        account.eta,
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 3. DETAILED TRANSACTION AUDIT TABLE CARD
  // ====================================================================
  Widget _buildTransactionAuditCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE2EDE4), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildAuditRow("Transaction ID", transactionId, isBoldValue: true),
          const Divider(height: 18, color: Color(0xFFF1F5F2)),
          _buildAuditRow("Date & Time", dateTime),
          const Divider(height: 18, color: Color(0xFFF1F5F2)),
          _buildAuditRow("Payment method", account.title),
          const Divider(height: 18, color: Color(0xFFF1F5F2)),
          _buildAuditRow(
            "Status",
            "Processing",
            isGreenStatus: true,
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F2)),

          // Copy Reference Link Action
          GestureDetector(
            onTap: () => _copyReference(context),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Copy Reference",
                  style: GoogleFonts.inter(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF236830),
                  ),
                ),
                SizedBox(width: 3.w),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Color(0xFF236830),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuditRow(
    String label,
    String value, {
    bool isBoldValue = false,
    bool isGreenStatus = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: const Color(0xFF7A8C80),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 12.5.sp,
            fontWeight: isBoldValue || isGreenStatus
                ? FontWeight.bold
                : FontWeight.w500,
            color: isGreenStatus
                ? const Color(0xFF236830)
                : const Color(0xFF1E2D24),
          ),
        ),
      ],
    );
  }

  // ====================================================================
  // 4. SLA SUPPORT NOTICE CARD
  // ====================================================================
  Widget _buildSupportNoticeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F3), // Light mint background
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFD3E7D7), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: Color(0xFF236830),
            size: 16,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Money usually arrives in ",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF4A5568),
                      height: 1.35,
                    ),
                  ),
                  TextSpan(
                    text: "5–30 minutes",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  TextSpan(
                    text:
                        ". If not received within 2 hours, contact support with ref ",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                  TextSpan(
                    text: "$transactionId.",
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF236830),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 5. ACTION BUTTONS
  // ====================================================================
  Widget _buildDoneButton() {
    return GestureDetector(
      onTap: _returnToWallet,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: const Color(0xFF236830), // Solid forest green
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF236830).withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_outlined,
              size: 18,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              "Done — Back to Wallet",
              style: GoogleFonts.inter(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewTransactionsButton() {
    return GestureDetector(
      onTap: _returnToWallet,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFFE2EDE4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "View All Transactions",
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
                height: 1.1,
              ),
            ),
            SizedBox(width: 6.w),
            const Icon(
              Icons.arrow_outward_rounded,
              size: 15,
              color: Color(0xFF2D3748),
            ),
          ],
        ),
      ),
    );
  }
}
