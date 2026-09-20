import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/core/utils/constants/app_sizer.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF4EE), // Signature soft sage-mint
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Forest Green Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF236830),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(26.r),
                  bottomRight: Radius.circular(26.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                20.w,
                MediaQuery.of(context).padding.top + 14.h,
                20.w,
                20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Driver Earnings & Wallet",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Weekly total: ₦54,200 • Guaranteed weekly payouts",
                    style: GoogleFonts.inter(
                      fontSize: 12.5.sp,
                      color: const Color(0xFFD6E8DA),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Available Balance Card
                  _buildBalanceCard(),
                  SizedBox(height: 20.h),

                  // Today & Weekly Metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          title: "Today's Earnings",
                          value: "₦8,450",
                          subtext: "7 completed trips",
                          icon: Icons.today_rounded,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatBox(
                          title: "This Week",
                          value: "₦54,200",
                          subtext: "38 completed trips",
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Recent Payout Transactions Header
                  Text(
                    "Recent Payout Transactions",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  _buildTransactionItem(
                    title: "Automatic Weekly Payout",
                    bank: "First Bank •••• 4821",
                    date: "Yesterday, 4:30 PM",
                    amount: "₦36,500",
                    isPaid: true,
                  ),
                  SizedBox(height: 10.h),
                  _buildTransactionItem(
                    title: "Delivery Mission AGC-4821",
                    bank: "Instant wallet credit",
                    date: "Today, 11:20 AM",
                    amount: "+₦1,200",
                    isPaid: true,
                  ),
                  SizedBox(height: 10.h),
                  _buildTransactionItem(
                    title: "Delivery Mission AGC-4815",
                    bank: "Instant wallet credit",
                    date: "Today, 9:15 AM",
                    amount: "+₦2,100",
                    isPaid: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF236830), Color(0xFF194A23)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF236830).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AVAILABLE BALANCE",
            style: GoogleFonts.inter(
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF98D4A5),
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "₦42,650.00",
            style: GoogleFonts.inter(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    AppSnackBar.success("Withdrawal request submitted for processing.");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF236830),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Withdraw to Bank",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required String subtext,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF236830), size: 20.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E2D24),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7A8C80),
            ),
          ),
          Text(
            subtext,
            style: GoogleFonts.inter(
              fontSize: 9.5.sp,
              color: const Color(0xFF9EABA2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String bank,
    required String date,
    required String amount,
    required bool isPaid,
  }) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 38.h,
                height: 38.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F3ED),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(
                  Icons.arrow_downward_rounded,
                  color: Color(0xFF236830),
                  size: 20,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E2D24),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "$bank • $date",
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      color: const Color(0xFF7A8C80),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF236830),
            ),
          ),
        ],
      ),
    );
  }
}
