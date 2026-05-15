import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/form_panel.dart';

class AccountFormScreen extends StatefulWidget {
  const AccountFormScreen({super.key, this.isEdit = false});

  final bool isEdit;

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final name = TextEditingController();
  final type = TextEditingController(text: 'Bank');
  final balance = TextEditingController();
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
      final data = dataMap(await ApiService.get('/accounts/$id'));
      name.text = textOf(data['account_name'], '');
      type.text = textOf(data['account_type'], '');
      balance.text = textOf(data['balance'], '');
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> save() async {
    setState(() => loading = true);
    final payload = {
      'account_name': name.text.trim(),
      'account_type': type.text.trim(),
      'balance': double.tryParse(balance.text) ?? 0,
    };
    try {
      if (widget.isEdit) {
        await ApiService.put('/accounts/$id', payload);
      } else {
        await ApiService.post('/accounts', payload);
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
      title: widget.isEdit ? 'Edit Account' : 'Add Account',
      loading: loading,
      child: FormPanel(
        error: error,
        children: [
          AppTextField(label: 'Account Name', controller: name),
          AppTextField(label: 'Account Type', controller: type),
          AppTextField(
            label: 'Balance',
            controller: balance,
            keyboardType: TextInputType.number,
          ),
          PrimaryButton(label: 'Save Account', onPressed: save),
        ],
      ),
    );
  }
}
