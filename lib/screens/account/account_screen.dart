import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/data_card.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/summary_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool loading = true;
  String error = '';
  List<Map<String, dynamic>> accounts = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      accounts = dataList(await ApiService.get('/accounts'));
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> remove(int id) async {
    await ApiService.delete('/accounts/$id');
    await load();
  }

  @override
  Widget build(BuildContext context) {
    final total = accounts.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse('${item['balance'] ?? 0}') ?? 0),
    );

    return AppShell(
      title: 'Accounts',
      loading: loading,
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, '/accounts/add').then((_) => load()),
          icon: const Icon(Icons.add),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          SummaryStrip(
            items: {
              'Total Balance': rupiah(total),
              'Accounts': '${accounts.length}',
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: accounts.map((account) {
              return DataCard(
                title: textOf(account['account_name']),
                subtitle: textOf(account['account_type']),
                trailing: rupiah(account['balance']),
                onEdit: () => Navigator.pushNamed(
                  context,
                  '/accounts/edit',
                  arguments: account['id'],
                ).then((_) => load()),
                onDelete: () => remove(account['id'] as int),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
