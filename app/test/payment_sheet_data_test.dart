import 'package:flutter_test/flutter_test.dart';
import 'package:stripe_payments/payment_sheet_data.dart';

void main() {
  test('reads the payment-sheet function response', () {
    final data = PaymentSheetData.fromJson({
      'paymentIntent': 'pi_123_secret_456',
      'customer': 'cus_123',
      'customerSession': 'cuss_secret_789',
    });

    expect(data.paymentIntentClientSecret, 'pi_123_secret_456');
    expect(data.customerId, 'cus_123');
    expect(data.customerSessionClientSecret, 'cuss_secret_789');
  });
}
