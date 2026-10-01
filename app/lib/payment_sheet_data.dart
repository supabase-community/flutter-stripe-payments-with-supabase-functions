class PaymentSheetData {
  const PaymentSheetData({
    required this.paymentIntentClientSecret,
    required this.customerId,
    required this.customerSessionClientSecret,
  });

  factory PaymentSheetData.fromJson(Map<String, dynamic> json) {
    return PaymentSheetData(
      paymentIntentClientSecret: json['paymentIntent'] as String,
      customerId: json['customer'] as String,
      customerSessionClientSecret: json['customerSession'] as String,
    );
  }

  final String paymentIntentClientSecret;
  final String customerId;
  final String customerSessionClientSecret;
}
