import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_frame.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/feedback_boxes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> submit() async {
    setState(() {
      loading = true;
      error = '';
    });
    try {
      await AuthService.login(
        email: email.text.trim(),
        password: password.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'PLEASE ENTER YOUR CREDENTIALS TO ACCESS YOUR ATELIER.',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 34),
          if (error.isNotEmpty) ErrorBox(error),
          AppTextField(
            label: 'Email address',
            controller: email,
            hint: 'name@company.com',
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            controller: password,
            hint: 'Password',
            obscure: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: AppColors.green,
              ),
              const Text(
                'Keep me logged in',
                style: TextStyle(color: Colors.white60),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Forgot?')),
            ],
          ),
          const SizedBox(height: 18),
          PrimaryButton(
            label: loading ? 'Authenticating...' : 'Log in to your account',
            onPressed: loading ? null : submit,
          ),
          const SizedBox(height: 26),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Don't have an account? Sign up for free"),
            ),
          ),
        ],
      ),
    );
  }
}
