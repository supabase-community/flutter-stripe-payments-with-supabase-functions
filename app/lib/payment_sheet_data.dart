class const PaymentSheetData({
  required final String paymentIntentClientSecret,
  required final String customerId,
  required final String customerSessionClientSecret,
}) {
  factory fromJson(Map<String, dynamic> json) => switch (json) {
    {
      'paymentIntent': final String paymentIntentClientSecret,
      'customer': final String customerId,
      'customerSession': final String customerSessionClientSecret,
    } =>
      PaymentSheetData(
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerSessionClientSecret: customerSessionClientSecret,
      ),
    _ => throw FormatException('Unexpected payment-sheet response', json),
  };
}
