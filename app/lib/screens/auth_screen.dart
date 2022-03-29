import 'package:flutter/material.dart';
import 'package:stripe_example/screens/payment_screen.dart';
import 'package:stripe_example/utils.dart';
import 'package:stripe_example/widgets/loading_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text('Email'),
            ),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text('Password'),
            ),
          ),
          const SizedBox(height: 18),
          LoadingButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              final res = await supabaseClient.auth.signUp(email, password);
              if (res.error != null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing up: ${res.error!.message}'),
                    ),
                  );
                }
                return;
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully signed up!'),
                  ),
                );
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PaymentScreen(),
                  ),
                );
              }
            },
            text: 'Sign up',
          ),
          const SizedBox(height: 18),
          LoadingButton(
            onPressed: () async {
              final email = _emailController.text;
              final password = _passwordController.text;
              final res = await supabaseClient.auth
                  .signIn(email: email, password: password);
              if (res.error != null) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error signing in: ${res.error!.message}'),
                    ),
                  );
                }
                return;
              }
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully signed in!'),
                  ),
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PaymentScreen(),
                  ),
                );
              }
            },
            text: 'Sign in',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
