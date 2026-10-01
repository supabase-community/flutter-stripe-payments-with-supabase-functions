const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);
const stripePublishableKey = String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
const stripeMerchantIdentifier = String.fromEnvironment(
  'STRIPE_MERCHANT_IDENTIFIER',
  defaultValue: 'merchant.io.supabase.stripepayments',
);

void ensureConfigured() {
  final missing = [
    if (supabaseUrl.isEmpty) 'SUPABASE_URL',
    if (supabasePublishableKey.isEmpty) 'SUPABASE_PUBLISHABLE_KEY',
    if (stripePublishableKey.isEmpty) 'STRIPE_PUBLISHABLE_KEY',
  ];
  if (missing.isNotEmpty) {
    throw StateError(
      'Missing ${missing.join(', ')}. Run the app with '
      '--dart-define-from-file=config.json, see the README.',
    );
  }
}
