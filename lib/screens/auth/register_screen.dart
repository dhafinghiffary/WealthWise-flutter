import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_frame.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/feedback_boxes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool loading = false;
  String message = '';
  String error = '';

  Future<void> submit() async {
    if (password.text != confirm.text) {
      setState(() => error = 'Passwords do not match. Please try again.');
      return;
    }
    setState(() {
      loading = true;
      error = '';
      message = '';
    });
    try {
      await AuthService.register(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text,
        passwordConfirmation: confirm.text,
      );
      setState(() => message = 'Account created successfully. Please login.');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
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
            'Create an Atelier Account',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'JOIN WEALTHWISE AND BEGIN MANAGING YOUR ASSETS WITH PRECISION.',
            style: TextStyle(
              color: AppColors.green,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 28),
          if (error.isNotEmpty) ErrorBox(error),
          if (message.isNotEmpty) SuccessBox(message),
          AppTextField(
            label: 'Your name',
            controller: name,
            hint: 'e.g. John Doe',
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Email address',
            controller: email,
            hint: 'name@company.com',
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Password',
                  controller: password,
                  obscure: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  label: 'Confirm',
                  controller: confirm,
                  obscure: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: true,
                onChanged: (_) {},
                activeColor: AppColors.green,
              ),
              const Expanded(
                child: Text(
                  'I agree to the Terms of Service and Privacy Policy.',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            label: loading ? 'Processing...' : 'Sign up',
            onPressed: loading ? null : submit,
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Already a member? Sign in here'),
          ),
        ],
      ),
    );
  }
}
