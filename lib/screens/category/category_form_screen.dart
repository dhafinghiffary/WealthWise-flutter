import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/form_panel.dart';

class CategoryFormScreen extends StatefulWidget {
  const CategoryFormScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends State<CategoryFormScreen> {
  final name = TextEditingController();
  final budget = TextEditingController();
  String type = 'EXPENSE';
  String period = 'MONTHLY';
  bool loading = false;
  String error = '';
  int? id;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id ??= routeId(context);
    if (widget.isEdit && id != null && name.text.isEmpty) load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final data = dataMap(await ApiService.get('/categories/$id'));
      name.text = textOf(data['category_name'], '');
      budget.text = textOf(data['budget_limit'], '');
      type = textOf(data['type'], 'EXPENSE');
      period = textOf(data['budget_period'], 'MONTHLY');
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    setState(() => loading = true);
    final payload = {
      'category_name': name.text.trim(),
      'type': type,
      'budget_limit': type == 'EXPENSE' && budget.text.isNotEmpty
          ? double.tryParse(budget.text) ?? 0
          : null,
      'budget_period': type == 'EXPENSE' ? period : null,
    };
    try {
      if (widget.isEdit) {
        await ApiService.put('/categories/$id', payload);
      } else {
        await ApiService.post('/categories/add', payload);
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
      title: widget.isEdit ? 'Edit Category' : 'Add Category',
      loading: loading,
      child: FormPanel(
        error: error,
        children: [
          AppTextField(label: 'Category Name', controller: name),
          DropdownButtonFormField<String>(
            key: ValueKey('category-type-$type'),
            initialValue: type,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'INCOME', child: Text('INCOME')),
              DropdownMenuItem(value: 'EXPENSE', child: Text('EXPENSE')),
            ],
            onChanged: (v) => setState(() => type = v ?? type),
          ),
          if (type == 'EXPENSE') ...[
            AppTextField(
              label: 'Budget Limit',
              controller: budget,
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              key: ValueKey('category-period-$period'),
              initialValue: period,
              decoration: const InputDecoration(labelText: 'Budget Period'),
              items: const [
                'WEEKLY',
                'MONTHLY',
                'YEARLY',
              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => period = v ?? period),
            ),
          ],
          PrimaryButton(label: 'Save Category', onPressed: save),
        ],
      ),
    );
  }
}
