class PaymentResponse {
  final String paymentUrl;

  PaymentResponse({required this.paymentUrl});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    final paymentUrl = json['result'] ?? '';
    if (paymentUrl.isEmpty) {
      print("Payment URL is empty in the API response.");
    }
    return PaymentResponse(paymentUrl: paymentUrl);
  }
}
