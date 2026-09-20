import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';
import '../../controllers/earnings_controller.dart';
import '../delivery_main_screen.dart';
import 'withdraw_earnings_screen.dart';
import 'withdrawal_success_screen.dart';

class WithdrawalRequestedScreen extends StatelessWidget {
  final double requestedAmount;
  final double fee;
  final double netAmount;
  final PayoutAccount account;

  const WithdrawalRequestedScreen({
    super.key,
    this.requestedAmount = 5000.0,
    this.fee = 75.0,
    this.netAmount = 4925.0,
    this.account = const PayoutAccount(
      id: 'momo_1',
      title: 'MTN Mobile Money',
      subtitle: '+234 803 ••• ••98',
      owner: 'Emeka Okafor',
      isDefault: true,
      isMobileMoney: true,
      eta: '5–30 min',
    ),
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

  void _goToSuccessReceipt() {
    _confirmAndExecuteWithdrawal();
  }

  void _confirmAndExecuteWithdrawal() {
    // Deduct from EarningsController upon final confirmation
    if (Get.isRegistered<EarningsController>()) {
      final earningsCtrl = Get.find<EarningsController>();
      final currentNum = double.tryParse(
            earningsCtrl.availableBalance.value.replaceAll(',', ''),
          ) ??
          23450.0;
      final remaining = (currentNum - requestedAmount).clamp(0.0, 9999999.0);
      earningsCtrl.availableBalance.value = _formatAmount(remaining);
    }

    // Navigate to Withdrawal Successful Screen
    Get.to(
      () => WithdrawalSuccessScreen(
        requestedAmount: requestedAmount,
        fee: fee,
        netAmount: netAmount,
        account: account,
      ),
      transition: Transition.fadeIn,
    );
  }

  String get _etaShort {
    if (account.eta.contains('–')) {
      final parts = account.eta.split('–');
      return "~${parts[0].trim()} min";
    }
    if (account.eta.contains('business')) {
      return "~1-2 days";
    }
    return "~15 min";
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
              // 1. Dark Green Ambient Header with Bokeh circles & Center Badge
              _buildAmbientHeader(context),

              // 2. Body Details
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 28.h),
                child: Column(
                  children: [
                    // Headline
                    Text(
                      "Withdrawal Requested!",
                      style: GoogleFonts.inter(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF152218),
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),

                    // Subtitle: Your money is on its way to MTN Mobile Money.
                    Text.rich(
                      TextSpan(
                        text: "Your money is on its way to ",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          color: const Color(0xFF55685B),
                        ),
                        children: [
                          TextSpan(
                            text: "${account.title}.",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF152218),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.h),

                    // 3. Amount Sent Green Card (Interactive tap opens full receipt)
                    _buildAmountSentCard(),
                    SizedBox(height: 16.h),

                    // 4. Estimated Arrival Card
                    _buildEstimatedArrivalCard(),
                    SizedBox(height: 24.h),

                    // 5. Primary Action: Confirm Withdrawal Button
                    _buildConfirmWithdrawalButton(),
                    SizedBox(height: 12.h),

                    // 6. Secondary Action: Back to Wallet Button (Outlined with Green Border)
                    _buildBackToWalletButton(),
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
  // 1. AMBIENT HEADER WITH BOKEH CIRCLES & WHITE CHECK BADGE
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
          // Bokeh Circle Top-Right
          Positioned(
            top: 20.h,
            right: -20.w,
            child: Container(
              width: 140.h,
              height: 140.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.045),
              ),
            ),
          ),

          // Bokeh Circle Mid-Left
          Positioned(
            top: 60.h,
            left: -30.w,
            child: Container(
              width: 120.h,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Bokeh Circle Bottom-Right
          Positioned(
            bottom: -15.h,
            right: 40.w,
            child: Container(
              width: 100.h,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.035),
              ),
            ),
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

          // Center White Circular Badge with Green Ring Checkmark
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 24.h),
              width: 74.h,
              height: 74.h,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Container(
                width: 44.h,
                height: 44.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF236830),
                    width: 3.2,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.check_rounded,
                  color: const Color(0xFF236830),
                  size: 26.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 2. AMOUNT SENT GREEN CARD
  // ====================================================================
  Widget _buildAmountSentCard() {
    return GestureDetector(
      onTap: _goToSuccessReceipt,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
            // AMOUNT SENT header
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

            // Large Net Amount Display: ₦4,925
            Text(
              "₦${_formatAmount(netAmount)}",
              style: GoogleFonts.inter(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 16.h),

            // Bottom 3-Column Stats Container (REQUESTED, FEE, ETA)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  // 1. REQUESTED
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "₦${_formatAmount(requestedAmount)}",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "REQUESTED",
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA3DEB0),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 24.h,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),

                  // 2. FEE
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "₦${_formatAmount(fee)}",
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "FEE",
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA3DEB0),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    width: 1,
                    height: 24.h,
                    color: Colors.white.withValues(alpha: 0.18),
                  ),

                  // 3. ETA
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          _etaShort,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "ETA",
                          style: GoogleFonts.inter(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFA3DEB0),
                            letterSpacing: 0.4,
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
      ),
    );
  }

  // ====================================================================
  // 3. ESTIMATED ARRIVAL CARD
  // ====================================================================
  Widget _buildEstimatedArrivalCard() {
    final accountSummary = account.isMobileMoney
        ? "${account.title.split(' ')[0]} MoMo ${account.subtitle}"
        : "${account.title} ${account.subtitle}";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE2EDE4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Clock rounded mint container
          Container(
            width: 42.h,
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.schedule_rounded,
              color: const Color(0xFF236830),
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Estimated Arrival",
                  style: GoogleFonts.inter(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E2D24),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "${account.eta} · $accountSummary",
                  style: GoogleFonts.inter(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF7A8C80),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ====================================================================
  // 4. CONFIRM WITHDRAWAL PRIMARY BUTTON
  // ====================================================================
  Widget _buildConfirmWithdrawalButton() {
    return GestureDetector(
      onTap: _confirmAndExecuteWithdrawal,
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
            Icon(
              Icons.check_circle_outline_rounded,
              size: 19.sp,
              color: Colors.white,
            ),
            SizedBox(width: 8.w),
            Text(
              "Confirm Withdrawal",
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

  // ====================================================================
  // 5. BACK TO WALLET OUTLINED BUTTON
  // ====================================================================
  Widget _buildBackToWalletButton() {
    return GestureDetector(
      onTap: _returnToWallet,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: const Color(0xFF236830),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF236830).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "Back to Wallet",
          style: GoogleFonts.inter(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF236830),
          ),
        ),
      ),
    );
  }
}
