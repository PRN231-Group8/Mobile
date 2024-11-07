class Transaction {
  final String id;
  final String userId;
  final String status;
  final double amount;
  final DateTime createDate;

  Transaction({
    required this.id,
    required this.userId,
    required this.status,
    required this.amount,
    required this.createDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      createDate: DateTime.parse(json['createDate']),
    );
  }
}
