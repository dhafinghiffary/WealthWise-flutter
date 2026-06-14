import 'package:flutter/material.dart';

import 'card_panel.dart';

class SummaryStrip extends StatelessWidget {
  const SummaryStrip({super.key, required this.items});

  final Map<String, String> items;

  @override
  Widget build(BuildContext context) {
    final entries = items.entries.toList();
    return CardPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cols = (constraints.maxWidth / 150)
              .floor()
              .clamp(1, entries.length);
          final rows = <Widget>[];
          for (var i = 0; i < entries.length; i += cols) {
            final end = (i + cols).clamp(0, entries.length);
            final slice = entries.sublist(i, end);
            rows.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var j = 0; j < cols; j++)
                    Expanded(
                      child: j < slice.length
                          ? _Stat(label: slice[j].key, value: slice[j].value)
                          : const SizedBox.shrink(),
                    ),
                ],
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var k = 0; k < rows.length; k++) ...[
                if (k > 0) const SizedBox(height: 18),
                rows[k],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
