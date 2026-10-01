import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class const SignInScreen({super.key}) extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  GoTrueClient get _auth => Supabase.instance.client.auth;

  String get _email => _emailController.text.trim();

  String get _password => _passwordController.text;

  Future<void> _signIn() => _submit(() async {
    await _auth.signInWithPassword(email: _email, password: _password);
  });

  Future<void> _signUp() => _submit(() async {
    final response = await _auth.signUp(email: _email, password: _password);
    if (response.session == null) {
      _showMessage('Check your inbox to confirm your email address.');
    }
  });

  Future<void> _submit(Future<void> Function() action) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await action();
    } on AuthException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const .all(16),
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: .emailAddress,
              autofillHints: const [AutofillHints.email],
              textInputAction: .next,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              validator: (value) => value == null || !value.contains('@')
                  ? 'Enter a valid email address'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              onFieldSubmitted: (_) => _signIn(),
              validator: (value) => value == null || value.length < 6
                  ? 'Use at least 6 characters'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isLoading ? null : _signIn,
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _isLoading ? null : _signUp,
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}
