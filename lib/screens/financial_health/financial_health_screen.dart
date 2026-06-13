import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/card_panel.dart';
import '../../widgets/data_card.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/section_header.dart';
import '../../widgets/summary_card.dart';

class FinancialHealthScreen extends StatefulWidget {
  const FinancialHealthScreen({super.key});

  @override
  State<FinancialHealthScreen> createState() => _FinancialHealthScreenState();
}

class _FinancialHealthScreenState extends State<FinancialHealthScreen> {
  bool loading = true;
  String error = '';
  Map<String, dynamic> data = {};
  final input = TextEditingController();
  final messages = <Map<String, String>>[
    {
      'role': 'assistant',
      'content':
          'Halo, saya WealthWise AI Planner. Mau bahas keuangan bagian mana?',
    },
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      data = dataMap(await ApiService.get('/financial-health'));
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> send() async {
    final text = input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      messages.add({'role': 'user', 'content': text});
      input.clear();
    });
    try {
      final res = dataMap(
        await ApiService.post('/financial-health/chat', {
          'messages': messages.where((m) => m['role'] != 'system').toList(),
        }),
      );
      setState(
        () => messages.add({
          'role': 'assistant',
          'content': textOf(res['reply'], 'Tidak ada balasan.'),
        }),
      );
    } catch (e) {
      setState(
        () => messages.add({'role': 'assistant', 'content': e.toString()}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = dataMap(data['summary']);
    return AppShell(
      title: 'Financial Health',
      loading: loading,
      onRefresh: load,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          SummaryStrip(
            items: {
              'Score': textOf(summary['score'], '0'),
              'Saving Ratio': '${textOf(summary['savingRatio'], '0')}%',
              'Expense Ratio': '${textOf(summary['expenseRatio'], '0')}%',
              'Emergency Fund':
                  '${textOf(summary['emergencyMonths'], '0')} months',
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: data.entries
                .where((entry) => entry.value is! Map && entry.value is! List)
                .map(
                  (entry) =>
                      DataCard(title: entry.key, subtitle: textOf(entry.value)),
                )
                .toList(),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'AI Planner'),
          CardPanel(
            child: Column(
              children: [
                SizedBox(
                  height: 280,
                  child: ListView(
                    children: messages.map((message) {
                      final isUser = message['role'] == 'user';
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 520),
                          decoration: BoxDecoration(
                            color: isUser
                                ? AppColors.green
                                : Colors.white.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(textOf(message['content'])),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: input,
                        decoration: const InputDecoration(
                          hintText: 'Ask about your finance...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
