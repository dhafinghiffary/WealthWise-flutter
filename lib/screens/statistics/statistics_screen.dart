import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/card_panel.dart';
import '../../widgets/data_card.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/mini_bars.dart';
import '../../widgets/section_header.dart';
import '../../widgets/seg_button.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/transaction_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String type = 'outcome';
  String period = 'month';
  bool loading = true;
  String error = '';
  Map<String, dynamic> stats = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      stats = dataMap(
        await ApiService.get(
          '/statistics',
          query: {'type': type, 'period': period},
        ),
      );
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = dataList(stats['top_categories']);
    final chart = {
      for (final item in dataList(stats['weekly_chart']))
        textOf(item['day']): item['total'],
    };

    return AppShell(
      title: 'Statistics',
      loading: loading,
      onRefresh: load,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SegButton(
                label: 'Outcome',
                active: type == 'outcome',
                onTap: () => _changeType('outcome'),
              ),
              SegButton(
                label: 'Income',
                active: type == 'income',
                onTap: () => _changeType('income'),
              ),
              SegButton(
                label: 'Month',
                active: period == 'month',
                onTap: () => _changePeriod('month'),
              ),
              SegButton(
                label: '3 Months',
                active: period == '3months',
                onTap: () => _changePeriod('3months'),
              ),
              SegButton(
                label: 'Year',
                active: period == 'year',
                onTap: () => _changePeriod('year'),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SummaryStrip(
            items: {
              'Income': rupiah(stats['total_income']),
              'Expense': rupiah(stats['total_expense']),
              'Net Savings': rupiah(stats['net_savings']),
            },
          ),
          const SizedBox(height: 20),
          CardPanel(child: MiniBars(values: chart)),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Top Categories'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: top.map((category) {
              return DataCard(
                title: textOf(category['category_name']),
                subtitle: '${textOf(category['percentage'], '0')}% of total',
                trailing: rupiah(category['total']),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Transactions'),
          TransactionList(
            transactions: dataList(stats['transactions']),
            compact: true,
          ),
        ],
      ),
    );
  }

  void _changeType(String next) {
    type = next;
    load();
  }

  void _changePeriod(String next) {
    period = next;
    load();
  }
}
