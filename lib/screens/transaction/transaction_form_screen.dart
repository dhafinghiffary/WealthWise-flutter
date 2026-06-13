import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/date_field.dart';
import '../../widgets/form_panel.dart';
import '../../widgets/id_dropdown.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final amount = TextEditingController();
  final description = TextEditingController();
  final date = TextEditingController();
  String type = 'EXPENSE';
  int? accountId;
  int? categoryId;
  int? toAccountId;
  int? id;
  bool loading = true;
  String error = '';
  List<Map<String, dynamic>> accounts = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    date.text = DateTime.now().toIso8601String().split('T').first;
  }

  Map<String, dynamic>? _prefill;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id ??= routeId(context);
    // Scanned-receipt data is passed as a Map route argument without an `id`.
    final args = ModalRoute.of(context)?.settings.arguments;
    if (!widget.isEdit && args is Map && args['id'] == null) {
      _prefill ??= Map<String, dynamic>.from(args);
    }
    if (accounts.isEmpty) load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      accounts = dataList(await ApiService.get('/accounts'));
      categories = dataList(await ApiService.get('/categories'));
      if (widget.isEdit && id != null) {
        final tx = dataMap(await ApiService.get('/transactions/$id'));
        amount.text = textOf(tx['transaction_amount'], '');
        description.text = textOf(tx['description'], '');
        date.text = textOf(tx['transaction_date'], date.text).split(' ').first;
        type = textOf(tx['transaction_type'], type);
        accountId = int.tryParse('${tx['account_id'] ?? ''}');
        categoryId = int.tryParse('${tx['category_id'] ?? ''}');
        toAccountId = int.tryParse('${tx['to_account_id'] ?? ''}');
      } else {
        accountId = accounts.isNotEmpty ? accounts.first['id'] as int : null;
        categoryId = categories.isNotEmpty
            ? categories.first['id'] as int
            : null;
        if (_prefill != null) {
          amount.text = textOf(_prefill!['amount'], amount.text);
          description.text = textOf(_prefill!['description'], description.text);
          date.text = textOf(
            _prefill!['transaction_date'],
            date.text,
          ).split(' ').first;
          type = textOf(_prefill!['type'], type);
          final expenseCategory = categories.firstWhere(
            (c) => c['type'] == type,
            orElse: () => <String, dynamic>{},
          );
          if (expenseCategory['id'] is int) {
            categoryId = expenseCategory['id'] as int;
          }
        }
      }
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    setState(() => loading = true);
    final payload = {
      'account_id': accountId,
      'type': type,
      'amount': double.tryParse(amount.text) ?? 0,
      'transaction_date': date.text,
      'category_id': type == 'TRANSFER' ? null : categoryId,
      'to_account_id': type == 'TRANSFER' ? toAccountId : null,
      'description': description.text.trim(),
    };
    try {
      if (widget.isEdit) {
        await ApiService.put('/transactions/$id', payload);
      } else {
        await ApiService.post('/transactions/add', payload);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: widget.isEdit ? 'Edit Transaction' : 'Add Transaction',
      loading: loading,
      child: FormPanel(
        error: error,
        children: [
          DropdownButtonFormField<String>(
            key: ValueKey('transaction-type-$type'),
            initialValue: type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              'INCOME',
              'EXPENSE',
              'TRANSFER',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => type = v ?? type),
          ),
          IdDropdown(
            label: 'Account',
            value: accountId,
            values: accounts,
            nameKey: 'account_name',
            onChanged: (v) => setState(() => accountId = v),
          ),
          if (type == 'TRANSFER')
            IdDropdown(
              label: 'To Account',
              value: toAccountId,
              values: accounts,
              nameKey: 'account_name',
              onChanged: (v) => setState(() => toAccountId = v),
            )
          else
            IdDropdown(
              label: 'Category',
              value: categoryId,
              values: categories.where((c) => c['type'] == type).toList(),
              nameKey: 'category_name',
              onChanged: (v) => setState(() => categoryId = v),
            ),
          AppTextField(
            label: 'Amount',
            controller: amount,
            keyboardType: TextInputType.number,
          ),
          DateField(label: 'Transaction Date', controller: date),
          AppTextField(
            label: 'Description',
            controller: description,
            maxLines: 3,
          ),
          PrimaryButton(label: 'Save Transaction', onPressed: save),
        ],
      ),
    );
  }
}
