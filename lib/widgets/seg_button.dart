import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class SegButton extends StatelessWidget {
  const SegButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: active,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.green,
    );
  }
}
