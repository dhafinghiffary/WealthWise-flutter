import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/utils/app_helpers.dart';
import 'card_panel.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({
    super.key,
    required this.transactions,
    this.onEdit,
    this.onDelete,
    this.compact = false,
  });

  final List<Map<String, dynamic>> transactions;
  final ValueChanged<int>? onEdit;
  final ValueChanged<int>? onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const CardPanel(
        child: Text(
          'No transactions yet.',
          style: TextStyle(color: Colors.white60),
        ),
      );
    }

    return Column(
      children: transactions.map((tx) {
        final type = textOf(tx['transaction_type']);
        final isIncome = type == 'INCOME';
        final category = tx['category'] is Map
            ? textOf(tx['category']['name'])
            : textOf(tx['category_id']);
        final account = tx['account'] is Map
            ? textOf(tx['account']['name'])
            : textOf(tx['account_id']);

        return CardPanel(
          margin: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: (isIncome ? AppColors.green : Colors.redAccent)
                    .withValues(alpha: .16),
                child: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? AppColors.green2 : Colors.redAccent,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      textOf(tx['description'], category),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '$account - ${textOf(tx['transaction_date']).split(' ').first}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                rupiah(tx['transaction_amount']),
                style: TextStyle(
                  color: isIncome ? AppColors.green2 : Colors.redAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (!compact && onEdit != null && onDelete != null) ...[
                IconButton(
                  onPressed: () => onEdit!(tx['id'] as int),
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  onPressed: () => onDelete!(tx['id'] as int),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
