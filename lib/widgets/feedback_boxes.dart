import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: .10),
        border: Border.all(color: Colors.red.withValues(alpha: .35)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: const TextStyle(color: Colors.redAccent)),
    );
  }
}

class SuccessBox extends StatelessWidget {
  const SuccessBox(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: .15),
        border: Border.all(color: AppColors.green.withValues(alpha: .5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: const TextStyle(color: AppColors.green2)),
    );
  }
}
