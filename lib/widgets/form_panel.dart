import 'package:flutter/material.dart';

import 'card_panel.dart';
import 'feedback_boxes.dart';

class FormPanel extends StatelessWidget {
  const FormPanel({super.key, required this.children, this.error = ''});

  final List<Widget> children;
  final String error;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: CardPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error.isNotEmpty) ErrorBox(error),
            for (final child in children) ...[
              child,
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}
