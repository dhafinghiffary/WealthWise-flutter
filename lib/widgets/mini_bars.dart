import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/app_helpers.dart';

class MiniBars extends StatelessWidget {
  const MiniBars({super.key, required this.values});

  final Map<String, dynamic> values;

  @override
  Widget build(BuildContext context) {
    final max = values.values
        .map((e) => double.tryParse('$e') ?? 0)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return Column(
      children: values.entries.map((entry) {
        final value = double.tryParse('${entry.value}') ?? 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  entry.key,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: max == 0 ? 0 : value / max,
                    minHeight: 10,
                    color: AppColors.green2,
                    backgroundColor: Colors.white.withValues(alpha: .09),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                rupiah(value),
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
