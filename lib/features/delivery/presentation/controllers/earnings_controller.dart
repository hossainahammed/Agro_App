import 'package:get/get.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';

class TransactionItem {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String amount;
  final bool isCredit;

  const TransactionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isCredit,
  });
}

class DailyChartData {
  final String day;
  final double amount;
  final double heightRatio;
  final bool isHighlighted;

  const DailyChartData({
    required this.day,
    required this.amount,
    required this.heightRatio,
    this.isHighlighted = false,
  });
}

class EarningsController extends GetxController {
  // Balance Visibility
  final RxBool isBalanceHidden = false.obs;

  // Primary Figures
  final RxString availableBalance = '23,450'.obs;
  final RxString lastUpdated = 'Today, 9:41 AM'.obs;

  // Card sub-metrics
  final RxString todayEarnings = '₦5,050'.obs;
  final RxString thisWeekEarnings = '₦68,200'.obs;
  final RxString thisMonthEarnings = '₦142,800'.obs;

  // 3 Quick Metrics Cards
  final RxInt allTimeDeliveries = 142.obs;
  final RxString avgTripEarnings = '₦2,890'.obs;
  final RxString pendingEarnings = '₦650'.obs;

  // Weekly Chart
  final RxString weeklyChartTotal = '₦68,100'.obs;
  final RxString weeklyDateRange = 'Jun 23–29'.obs;
  final RxInt selectedDayIndex = 4.obs; // Friday default selected

  final List<DailyChartData> weeklyChartBars = const [
    DailyChartData(day: 'Mon', amount: 7500, heightRatio: 0.44),
    DailyChartData(day: 'Tue', amount: 11500, heightRatio: 0.68),
    DailyChartData(day: 'Wed', amount: 6000, heightRatio: 0.35),
    DailyChartData(day: 'Thu', amount: 15500, heightRatio: 0.90),
    DailyChartData(
      day: 'Fri',
      amount: 10000,
      heightRatio: 0.58,
      isHighlighted: true,
    ),
    DailyChartData(day: 'Sat', amount: 11000, heightRatio: 0.64),
    DailyChartData(day: 'Sun', amount: 4000, heightRatio: 0.28),
  ];

  // Show all transactions toggle
  final RxBool showAllTransactions = true.obs;

  // 9 Transactions matching the design mockup exactly
  final RxList<TransactionItem> transactions = <TransactionItem>[
    const TransactionItem(
      id: 'TXN-8821',
      title: 'Delivery Payout',
      subtitle: 'AGC-5102 · Maize · 50 bags',
      date: 'Today, 9:41 AM',
      amount: '+₦3,200',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8819',
      title: 'Delivery Payout',
      subtitle: 'AGC-5099 · Tomatoes · 30 crates',
      date: 'Today, 7:15 AM',
      amount: '+₦1,850',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8812',
      title: 'Withdrawal',
      subtitle: 'To Zenith Bank ····4821',
      date: 'Yesterday, 6:00 PM',
      amount: '−₦10,000',
      isCredit: false,
    ),
    const TransactionItem(
      id: 'TXN-8808',
      title: 'Delivery Payout',
      subtitle: 'AGC-5087 · Mangoes · 25 crates',
      date: 'Yesterday, 1:30 PM',
      amount: '+₦2,100',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8805',
      title: 'Delivery Payout',
      subtitle: 'AGC-5080 · Fresh Milk · 8 chums',
      date: 'Yesterday, 9:00 AM',
      amount: '+₦4,100',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8801',
      title: 'On-time Bonus',
      subtitle: 'Perfect week streak reward',
      date: 'Wed, 6:00 PM',
      amount: '+₦500',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8796',
      title: 'Delivery Payout',
      subtitle: 'AGC-5071 · Maize · 30 bags',
      date: 'Wed, 3:45 PM',
      amount: '+₦2,400',
      isCredit: true,
    ),
    const TransactionItem(
      id: 'TXN-8790',
      title: 'Withdrawal',
      subtitle: 'To Zenith Bank ····4821',
      date: 'Tue, 8:00 PM',
      amount: '−₦8,000',
      isCredit: false,
    ),
    const TransactionItem(
      id: 'TXN-8785',
      title: 'Delivery Payout',
      subtitle: 'AGC-5060 · Peppers · 20 crates',
      date: 'Tue, 2:15 PM',
      amount: '+₦1,600',
      isCredit: true,
    ),
  ].obs;

  void toggleBalanceVisibility() {
    isBalanceHidden.value = !isBalanceHidden.value;
  }

  void selectDay(int index) {
    selectedDayIndex.value = index;
    final item = weeklyChartBars[index];
    AppSnackBar.info('${item.day} Earnings: ₦${item.amount.toStringAsFixed(0)}');
  }

  void toggleShowAll() {
    showAllTransactions.value = !showAllTransactions.value;
  }

  void processWithdrawal(String amount) {
    AppSnackBar.success(
      'Withdrawal request for ₦$amount to Zenith Bank ····4821 initiated successfully.',
    );
  }

  void openStatementSheet() {
    AppSnackBar.info('Exporting monthly statement to PDF / CSV...');
  }
}
