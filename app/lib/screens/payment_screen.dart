import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:stripe_payments/payment_sheet_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  SupabaseClient get _supabase => Supabase.instance.client;

  Future<PaymentSheetData> _createPaymentSheet() async {
    final response = await _supabase.functions.invoke('payment-sheet');
    return PaymentSheetData.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> _checkout() async {
    setState(() => _isLoading = true);
    try {
      final data = await _createPaymentSheet();
      if (!mounted) {
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Supabase Store',
          paymentIntentClientSecret: data.paymentIntentClientSecret,
          customerId: data.customerId,
          customerSessionClientSecret: data.customerSessionClientSecret,
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            currencyCode: 'USD',
            testEnv: true,
          ),
          style: Theme.of(context).brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      _showMessage('Payment completed');
    } on StripeException catch (error) {
      if (error.error.code != FailureCode.Canceled) {
        _showMessage(error.error.localizedMessage ?? 'Payment failed');
      }
    } on FunctionException catch (error) {
      final details = error.details;
      final reason = details is Map ? details['error'] : details;
      _showMessage('Could not start the payment: $reason');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = _supabase.auth.currentUser?.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: _supabase.auth.signOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (email != null) Text('Signed in as $email'),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.shopping_bag_outlined),
              title: Text('Test product'),
              trailing: Text(r'$10.99'),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _isLoading ? null : _checkout,
            child: _isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Pay'),
          ),
        ],
      ),
    );
  }
}
