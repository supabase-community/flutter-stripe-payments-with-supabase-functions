import 'package:flutter/material.dart';
import 'package:stripe_payments/screens/payment_screen.dart';
import 'package:stripe_payments/screens/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class const App({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Payments',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color(0xFF635BFF)),
      ),
      darkTheme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color(0xFF635BFF),
          brightness: .dark,
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class const AuthGate({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Supabase.instance.client.auth;
    return StreamBuilder<AuthState>(
      stream: auth.onAuthStateChange,
      builder: (context, _) => auth.currentSession == null
          ? const SignInScreen()
          : const PaymentScreen(),
    );
  }
}
