import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/date_field.dart';
import '../../widgets/form_panel.dart';

class GoalFormScreen extends StatefulWidget {
  const GoalFormScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends State<GoalFormScreen> {
  final name = TextEditingController();
  final target = TextEditingController();
  final current = TextEditingController();
  final start = TextEditingController();
  final end = TextEditingController();
  final color = TextEditingController(text: '#10B981');
  String plan = 'MONTHLY';
  bool loading = false;
  String error = '';
  int? id;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    start.text = now.toIso8601String().split('T').first;
    end.text = DateTime(
      now.year + 1,
      now.month,
      now.day,
    ).toIso8601String().split('T').first;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id ??= routeId(context);
    if (widget.isEdit && id != null && name.text.isEmpty) load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final data = dataMap(await ApiService.get('/goals/$id'));
      name.text = textOf(data['goal_name'], '');
      target.text = textOf(data['target_amount'], '');
      current.text = textOf(data['current_amount'], '');
      start.text = textOf(data['start_date'], start.text).split(' ').first;
      end.text = textOf(data['target_date'], end.text).split(' ').first;
      color.text = textOf(data['color_theme'], '#10B981');
      plan = textOf(data['filling_plan'], plan);
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    setState(() => loading = true);
    final payload = {
      'goal_name': name.text.trim(),
      'target_amount': double.tryParse(target.text) ?? 0,
      if (widget.isEdit) 'current_amount': double.tryParse(current.text) ?? 0,
      'start_date': start.text,
      'target_date': end.text,
      'filling_plan': plan,
      'icon': 'target',
      'color_theme': color.text,
    };
    try {
      if (widget.isEdit) {
        await ApiService.put('/goals/$id', payload);
      } else {
        await ApiService.post('/goals', payload);
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
      title: widget.isEdit ? 'Edit Goal' : 'Add New Goal',
      loading: loading,
      child: FormPanel(
        error: error,
        children: [
          AppTextField(label: 'Goal Name', controller: name),
          AppTextField(
            label: 'Target Amount',
            controller: target,
            keyboardType: TextInputType.number,
          ),
          if (widget.isEdit)
            AppTextField(
              label: 'Current Amount',
              controller: current,
              keyboardType: TextInputType.number,
            ),
          DropdownButtonFormField<String>(
            key: ValueKey('goal-plan-$plan'),
            initialValue: plan,
            decoration: const InputDecoration(labelText: 'Filling Plan'),
            items: const [
              'DAILY',
              'WEEKLY',
              'MONTHLY',
            ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => plan = v ?? plan),
          ),
          DateField(label: 'Start Date', controller: start),
          DateField(label: 'Target Date', controller: end),
          AppTextField(label: 'Color Theme', controller: color),
          PrimaryButton(label: 'Save Goal', onPressed: save),
        ],
      ),
    );
  }
}
