import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/goal_card.dart';
import '../../widgets/summary_card.dart';

class SmartPlanningScreen extends StatefulWidget {
  const SmartPlanningScreen({super.key});

  @override
  State<SmartPlanningScreen> createState() => _SmartPlanningScreenState();
}

class _SmartPlanningScreenState extends State<SmartPlanningScreen> {
  bool loading = true;
  String error = '';
  List<Map<String, dynamic>> goals = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      goals = dataList(await ApiService.get('/goals'));
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> remove(int id) async {
    final ok = await confirmDialog(
      context,
      title: 'Delete Goal',
      message: 'This goal and its saved progress will be removed. Continue?',
    );
    if (!ok) return;
    try {
      await ApiService.delete('/goals/$id');
      await load();
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    }
  }

  Future<void> funds(Map<String, dynamic> goal) async {
    final amount = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${textOf(goal['goal_name'])}'),
        content: AppTextField(
          label: 'Amount',
          controller: amount,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'decrease'),
            child: const Text('Decrease'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'increase'),
            child: const Text('Increase'),
          ),
        ],
      ),
    );
    if (result == null) return;
    final value = double.tryParse(amount.text) ?? 0;
    if (value <= 0) {
      if (mounted) snack(context, 'Masukkan jumlah yang valid.');
      return;
    }
    try {
      await ApiService.put('/goals/${goal['id']}/funds', {
        'type': result,
        'amount': value,
      });
      await load();
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final saved = goals.fold<double>(
      0,
      (sum, goal) =>
          sum + (double.tryParse('${goal['current_amount'] ?? 0}') ?? 0),
    );
    final target = goals.fold<double>(
      0,
      (sum, goal) =>
          sum + (double.tryParse('${goal['target_amount'] ?? 0}') ?? 0),
    );

    return AppShell(
      title: 'Smart Planning',
      loading: loading,
      onRefresh: load,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/smart-planning/add-goal',
          ).then((_) => load()),
          icon: const Icon(Icons.add),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          SummaryStrip(
            items: {
              'Active Goals': '${goals.length}',
              'Saved': rupiah(saved),
              'Target': rupiah(target),
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: goals.map((goal) {
              return GoalCard(
                goal: goal,
                onFunds: () => funds(goal),
                onEdit: () => Navigator.pushNamed(
                  context,
                  '/smart-planning/edit',
                  arguments: goal['id'],
                ).then((_) => load()),
                onDelete: () => remove(goal['id'] as int),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
