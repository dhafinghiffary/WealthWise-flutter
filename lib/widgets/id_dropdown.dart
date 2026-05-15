import 'package:flutter/material.dart';

import '../core/utils/app_helpers.dart';

class IdDropdown extends StatelessWidget {
  const IdDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.nameKey,
    required this.onChanged,
  });

  final String label;
  final int? value;
  final List<Map<String, dynamic>> values;
  final String nameKey;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final ids = values.map((e) => e['id']).whereType<int>().toSet();
    return DropdownButtonFormField<int>(
      key: ValueKey('$label-$value-${values.length}'),
      initialValue: ids.contains(value) ? value : null,
      decoration: InputDecoration(labelText: label),
      items: values.map((item) {
        return DropdownMenuItem<int>(
          value: item['id'] as int,
          child: Text(textOf(item[nameKey])),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
