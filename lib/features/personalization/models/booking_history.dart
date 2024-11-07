import 'package:explore_now/features/personalization/models/transaction_model.dart';

class TourPackageHistory {
  final String id;
  final double totalPrice;
  final DateTime endDate;
  final List<Transaction> transactions;

  TourPackageHistory({
    required this.id,
    required this.totalPrice,
    required this.endDate,
    required this.transactions,
  });

  factory TourPackageHistory.fromJson(Map<String, dynamic> json) {
    return TourPackageHistory(
      id: json['id'] ?? '',
      totalPrice: (json['totalPrice'] as num).toDouble(),
      endDate: DateTime.parse(json['endDate']),
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
    );
  }
}
