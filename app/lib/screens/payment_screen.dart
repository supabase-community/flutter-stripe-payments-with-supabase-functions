import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:functions_client/functions_client.dart';
import 'package:stripe_example/config.dart';
import 'package:stripe_example/utils.dart';
import 'package:stripe_example/widgets/loading_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _step = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Stepper(
          controlsBuilder: (context, details) => Container(),
          currentStep: _step,
          steps: [
            Step(
              title: const Text('Init payment'),
              content: LoadingButton(
                onPressed: _initPaymentSheet,
                text: 'Init payment sheet',
              ),
            ),
            Step(
              title: const Text('Confirm payment'),
              content: LoadingButton(
                onPressed: _confirmPayment,
                text: 'Pay now',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initPaymentSheet() async {
    try {
      // 1. create payment intent on the server
      final data = await _createTestPaymentSheet();

      // create some billingdetails
      const billingDetails = BillingDetails(
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'US',
          line1: '1459  Circle Drive',
          line2: '',
          state: 'Texas',
          postalCode: '77063',
        ),
      ); // mocked data for tests

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: data['paymentIntent'] as String,
          merchantDisplayName: 'Flutter Stripe Store Demo',
          // Customer params
          customerId: data['customer'] as String,
          customerEphemeralKeySecret: data['ephemeralKey'] as String,
          // Extra params
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          primaryButtonColor: Colors.redAccent,
          billingDetails: billingDetails,
          testEnv: true,
          merchantCountryCode: 'DE',
        ),
      );

      setState(() {
        _step = 1;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> _confirmPayment() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        _step = 0;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment succesfully completed'),
          ),
        );
      }
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: $e'),
          ),
        );
      }
    }
  }

  Future<Map<String, dynamic>> _createTestPaymentSheet() async {
    final urlParts = supabaseUrl.split('.');
    final url = '${urlParts[0]}.functions.${urlParts[1]}.${urlParts[2]}';
    final headers = <String, String>{};
    headers['apiKey'] = supabaseAnonKey;
    headers['Authorization'] =
        'Bearer ${supabaseClient.auth.session()!.accessToken}';
    final functions = FunctionsClient(
      url: url,
      headers: headers,
    );
    final res = await functions.invoke('payment-sheet');
    final error = res.error;
    if (error != null) {
      throw error;
    }
    return res.data as Map<String, dynamic>;
  }
}
