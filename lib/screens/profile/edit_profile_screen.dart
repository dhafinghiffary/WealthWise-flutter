import 'package:flutter/material.dart';

import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/form_panel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final current = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final user = dataMap(await ApiService.get('/profile'));
      name.text = textOf(user['name'], '');
      email.text = textOf(user['email'], '');
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> saveProfile() async {
    try {
      await ApiService.put('/profile', {
        'name': name.text.trim(),
        'email': email.text.trim(),
      });
      if (mounted) snack(context, 'Profil berhasil diperbarui');
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  Future<void> savePassword() async {
    try {
      await ApiService.put('/profile/password', {
        'current_password': current.text,
        'password': password.text,
        'password_confirmation': confirm.text,
      });
      if (mounted) snack(context, 'Password berhasil diperbarui');
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Edit Profile',
      loading: loading,
      child: FormPanel(
        error: error,
        children: [
          AppTextField(label: 'Name', controller: name),
          AppTextField(label: 'Email', controller: email),
          PrimaryButton(label: 'Save Profile', onPressed: saveProfile),
          const Divider(height: 34),
          AppTextField(
            label: 'Current Password',
            controller: current,
            obscure: true,
          ),
          AppTextField(
            label: 'New Password',
            controller: password,
            obscure: true,
          ),
          AppTextField(
            label: 'Confirm New Password',
            controller: confirm,
            obscure: true,
          ),
          PrimaryButton(label: 'Update Password', onPressed: savePassword),
        ],
      ),
    );
  }
}
