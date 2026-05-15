import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: .35),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: AppColors.green),
    );
  }
}
