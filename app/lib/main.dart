import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payments/app.dart';
import 'package:stripe_payments/config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ensureConfigured();

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabasePublishableKey,
  );

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = stripeMerchantIdentifier;
  Stripe.urlScheme = 'stripepayments';
  await Stripe.instance.applySettings();

  runApp(const App());
}
