import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_helpers.dart';
import '../../services/api_service.dart';
import '../../widgets/app_shell.dart';
import '../../widgets/card_panel.dart';
import '../../widgets/feedback_boxes.dart';
import '../../widgets/summary_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  String error = '';
  Map<String, dynamic> user = {};
  Map<String, dynamic> dashboard = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      user = dataMap(await ApiService.get('/profile'));
      dashboard = dataMap(await ApiService.get('/dashboard'));
      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = dataMap(user['stats']);
    final summary = dataMap(dashboard['summary']);
    return AppShell(
      title: 'Profile',
      loading: loading,
      onRefresh: load,
      actions: [
        IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, '/profile/edit').then((_) => load()),
          icon: const Icon(Icons.edit),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (error.isNotEmpty) ErrorBox(error),
          CardPanel(
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.green,
                  child: Icon(Icons.person, size: 36),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textOf(user['name'], 'User'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        textOf(user['email']),
                        style: const TextStyle(color: Colors.white60),
                      ),
                      Text(
                        'Member since ${textOf(user['member_since'])}',
                        style: const TextStyle(color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SummaryStrip(
            items: {
              'Transactions': textOf(stats['total_transactions'], '0'),
              'Accounts': textOf(stats['total_accounts'], '0'),
              'Categories': textOf(stats['total_categories'], '0'),
              'Net Worth': rupiah(summary['net_balance']),
            },
          ),
        ],
      ),
    );
  }
}
