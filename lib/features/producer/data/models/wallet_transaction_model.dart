class WalletTransactionModel {
  final String id;
  final String title; // "Order Payment", "Bank Withdrawal", "Referral Bonus"
  final String subtitle; // e.g. "Aisha Musa · AGC-2841", "GTB ****4412"
  final double amount;
  final String time;
  final String dateGroup; // "TODAY", "YESTERDAY", "JUN 17, 2026"
  final String type; // "credit", "debit", "pending"
  final bool isPending;

  WalletTransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.dateGroup,
    required this.type,
    required this.isPending,
  });

  WalletTransactionModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    double? amount,
    String? time,
    String? dateGroup,
    String? type,
    bool? isPending,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      amount: amount ?? this.amount,
      time: time ?? this.time,
      dateGroup: dateGroup ?? this.dateGroup,
      type: type ?? this.type,
      isPending: isPending ?? this.isPending,
    );
  }
}
