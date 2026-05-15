import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/app_helpers.dart';
import 'card_panel.dart';
import 'custom_button.dart';

class GoalCard extends StatelessWidget {
  const GoalCard({
    super.key,
    required this.goal,
    required this.onFunds,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> goal;
  final VoidCallback onFunds;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final current = double.tryParse('${goal['current_amount'] ?? 0}') ?? 0;
    final target = double.tryParse('${goal['target_amount'] ?? 1}') ?? 1;
    final progress = target <= 0 ? 0.0 : (current / target).clamp(0.0, 1.0);

    return SizedBox(
      width: 330,
      child: CardPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.green,
                  child: Icon(Icons.flag_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    textOf(goal['goal_name']),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              color: AppColors.green2,
              backgroundColor: Colors.white10,
            ),
            const SizedBox(height: 10),
            Text(
              '${rupiah(current)} of ${rupiah(target)}',
              style: const TextStyle(color: Colors.white70),
            ),
            Text(
              '${(progress * 100).round()}% - ${textOf(goal['filling_plan'])}',
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 14),
            PrimaryButton(
              label: 'Add Funds',
              icon: Icons.savings_outlined,
              onPressed: onFunds,
            ),
          ],
        ),
      ),
    );
  }
}
