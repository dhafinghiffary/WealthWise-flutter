import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'card_panel.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String? subtitle;
  final String? trailing;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      child: CardPanel(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(color: Colors.white60),
                    ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        trailing!,
                        style: const TextStyle(
                          color: AppColors.green2,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              ),
          ],
        ),
      ),
    );
  }
}
