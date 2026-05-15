import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class CardPanel extends StatelessWidget {
  const CardPanel({super.key, required this.child, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.panel2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .06)),
      ),
      child: child,
    );
  }
}
