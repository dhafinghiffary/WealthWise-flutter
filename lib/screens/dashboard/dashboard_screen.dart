import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/mini_bars.dart';
import '../../widgets/quick_action.dart';
import '../../widgets/section_header.dart';
import '../../widgets/transaction_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = true;
  String error = '';
  Map<String, dynamic> summary = {};
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final res = dataMap(await ApiService.get('/dashboard'));
      summary = dataMap(res['summary']);
      transactions = dataList(res['recent_transactions']);
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Dashboard',
      loading: loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width >= 900
                    ? 680
                    : double.infinity,
                child: NetWorthCard(summary: summary),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width >= 900
                    ? 280
                    : double.infinity,
                child: Column(
                  children: [
                    QuickAction(
                      icon: Icons.document_scanner_outlined,
                      label: 'Scan Receipt',
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const ScanInfoDialog(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    QuickAction(
                      icon: Icons.computer_outlined,
                      label: 'Ask AI Finance Planner',
                      onTap: () =>
                          Navigator.pushNamed(context, '/financial-health'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Recent Transactions',
            actionLabel: 'View all',
            onAction: () => Navigator.pushNamed(context, '/transactions'),
          ),
          TransactionList(transactions: transactions, compact: true),
        ],
      ),
    );
  }
}

class ScanInfoDialog extends StatelessWidget {
  const ScanInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan Receipt'),
      content: const Text(
        'Fitur scan receipt ada di React sebagai upload gambar. Di Flutter ini endpoint backend sudah siap, sementara form manual tersedia.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/transactions/add'),
          child: const Text('Isi Manual'),
        ),
      ],
    );
  }
}

class NetWorthCard extends StatelessWidget {
  const NetWorthCard({super.key, required this.summary});

  final Map<String, dynamic> summary;

  @override
  Widget build(BuildContext context) {
    final chart = summary['chart'] is Map
        ? Map<String, dynamic>.from(summary['chart'])
        : <String, dynamic>{};

    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF065F46), Color(0xFF0F172A)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.green.withValues(alpha: .25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL NET WORTH',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            rupiah(summary['net_balance']),
            style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 30,
            runSpacing: 12,
            children: [
              Metric(
                label: 'Total Income',
                value: rupiah(summary['total_income']),
              ),
              Metric(
                label: 'Total Expenses',
                value: rupiah(summary['total_expense']),
              ),
              Metric(
                label: 'Top Category Expense',
                value: textOf(summary['top_category'], 'Belum ada data'),
                color: AppColors.orange,
              ),
            ],
          ),
          if (chart.isNotEmpty) ...[
            const SizedBox(height: 22),
            MiniBars(values: chart),
          ],
        ],
      ),
    );
  }
}

class Metric extends StatelessWidget {
  const Metric({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
