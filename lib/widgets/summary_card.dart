import 'package:flutter/material.dart';

import 'card_panel.dart';

class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key, required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.entries.map((entry) {
        return SizedBox(
          width: 220,
          child: CardPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
