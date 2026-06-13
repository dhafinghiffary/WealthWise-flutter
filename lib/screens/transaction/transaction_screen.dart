import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/transaction_card.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool loading = true;
  String error = '';
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      transactions = dataList(await ApiService.get('/transactions'));
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
      title: 'Delete Transaction',
      message: 'This transaction will be permanently removed. Continue?',
    );
    if (!ok) return;
    try {
      await ApiService.delete('/transactions/$id');
      await load();
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Transactions',
      loading: loading,
      onRefresh: load,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/transactions/add',
          ).then((_) => load()),
          icon: const Icon(Icons.add),
        ),
      ],
      child: Column(
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          TransactionList(
            transactions: transactions,
            onEdit: (id) => Navigator.pushNamed(
              context,
              '/transactions/edit',
              arguments: id,
            ).then((_) => load()),
            onDelete: remove,
          ),
        ],
      ),
    );
  }
}
