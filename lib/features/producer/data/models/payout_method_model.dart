class PayoutMethodModel {
  final String id;
  final String providerName; // e.g. "GTBank", "First Bank", "MTN MoMo"
  final String type; // "bank_account", "mobile_money"
  final String accountNumber; // e.g. "0123456789" or "+234 803 123 4567"
  final String accountName; // e.g. "Samuel Adeyemi"
  final DateTime addedDate;
  final bool isDefault;

  PayoutMethodModel({
    required this.id,
    required this.providerName,
    required this.type,
    required this.accountNumber,
    required this.accountName,
    required this.addedDate,
    required this.isDefault,
  });

  PayoutMethodModel copyWith({
    String? id,
    String? providerName,
    String? type,
    String? accountNumber,
    String? accountName,
    DateTime? addedDate,
    bool? isDefault,
  }) {
    return PayoutMethodModel(
      id: id ?? this.id,
      providerName: providerName ?? this.providerName,
      type: type ?? this.type,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      addedDate: addedDate ?? this.addedDate,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
