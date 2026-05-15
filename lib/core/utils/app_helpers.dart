import 'package:flutter/material.dart';

String rupiah(dynamic value) {
  final number = double.tryParse('${value ?? 0}') ?? 0;
  final whole = number.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
  }
  return 'Rp ${buffer.toString()}';
}

List<Map<String, dynamic>> dataList(dynamic value) {
  dynamic raw = value;
  if (raw is Map && raw['data'] != null) raw = raw['data'];
  if (raw is List) {
    return raw
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
  return [];
}

Map<String, dynamic> dataMap(dynamic value) {
  dynamic raw = value;
  if (raw is Map && raw['data'] is Map) raw = raw['data'];
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return {};
}

String textOf(dynamic value, [String fallback = '-']) {
  if (value == null || value.toString().isEmpty) return fallback;
  return value.toString();
}

int? routeId(BuildContext context) {
  final arg = ModalRoute.of(context)?.settings.arguments;
  if (arg is int) return arg;
  if (arg is String) return int.tryParse(arg);
  if (arg is Map && arg['id'] != null) {
    return int.tryParse(arg['id'].toString());
  }
  return null;
}

void snack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
