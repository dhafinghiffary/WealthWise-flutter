import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../services/receipt_service.dart';
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

  Future<void> _scanReceipt() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 70,
    );
    if (picked == null) return;

    setState(() => loading = true);
    try {
      final bytes = await picked.readAsBytes();
      final res = dataMap(
        await ReceiptService.scan(bytes: bytes, filename: picked.name),
      );
      if (!mounted) return;
      setState(() => loading = false);
      // Hand the parsed fields to the transaction form for review + confirm.
      await Navigator.pushNamed(context, '/transactions/add', arguments: res);
      await load();
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        snack(context, 'Scan gagal: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Dashboard',
      loading: loading,
      onRefresh: load,
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
                      onTap: _scanReceipt,
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
