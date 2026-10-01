import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stripe_payments/screens/sign_in_screen.dart';

void main() {
  testWidgets('validates the form before contacting Supabase', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.enterText(find.byType(TextFormField).last, '123');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
  });
}
