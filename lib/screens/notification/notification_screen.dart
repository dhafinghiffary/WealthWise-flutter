import 'package:flutter/material.dart';

import '../../widgets/app_shell.dart';
import '../../widgets/card_panel.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, this.title = 'Notifications'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: title,
      child: const CardPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No new notifications',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Budget alerts, goal reminders, and account updates will appear here.',
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
}
