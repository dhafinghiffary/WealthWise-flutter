import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/data_card.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/summary_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool loading = true;
  String error = '';
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      categories = dataList(await ApiService.get('/categories'));
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> remove(int id) async {
    await ApiService.delete('/categories/$id');
    await load();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Categories',
      loading: loading,
      actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/categories/add',
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
              'Total Categories': '${categories.length}',
              'Income':
                  '${categories.where((e) => e['type'] == 'INCOME').length}',
              'Expense':
                  '${categories.where((e) => e['type'] == 'EXPENSE').length}',
            },
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: categories.map((category) {
              final canEdit = category['user_id'] != null;
              return DataCard(
                title: textOf(category['category_name']),
                subtitle:
                    '${textOf(category['type'])}${category['budget_limit'] != null ? ' - Budget ${rupiah(category['budget_limit'])}' : ''}',
                trailing: category['spent'] != null
                    ? rupiah(category['spent'])
                    : null,
                onEdit: canEdit
                    ? () => Navigator.pushNamed(
                        context,
                        '/categories/edit',
                        arguments: category['id'],
                      ).then((_) => load())
                    : null,
                onDelete: canEdit ? () => remove(category['id'] as int) : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
