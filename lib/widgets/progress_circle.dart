import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({super.key, required this.value, this.size = 76});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0.0, 1.0);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: normalized,
            strokeWidth: 8,
            color: AppColors.green2,
            backgroundColor: Colors.white10,
          ),
          Center(
            child: Text(
              '${(normalized * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
