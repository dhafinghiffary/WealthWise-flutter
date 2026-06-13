import 'package:flutter/material.dart';

import '../core/utils/app_helpers.dart';

/// A read-only text field bound to a `YYYY-MM-DD` value that opens a native
/// date picker on tap. Keeps the underlying [controller] in sync so existing
/// form-submit logic that reads `controller.text` keeps working unchanged.
class DateField extends StatefulWidget {
  const DateField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  Future<void> _pick() async {
    final picked = await pickDate(context, widget.controller.text);
    if (picked == null) return;
    setState(() => widget.controller.text = picked);
    widget.onChanged?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      readOnly: true,
      onTap: _pick,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: 'YYYY-MM-DD',
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 20),
      ),
    );
  }
}
