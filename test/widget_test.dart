import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthwise_flutter/screens/auth/login_screen.dart';

void main() {
  testWidgets('WealthWise login screen renders', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log in to your account'), findsOneWidget);
  });
}
